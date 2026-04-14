@tool
class_name UnitRenderer
extends Node2D

## 单位渲染节点，负责机甲单位的 2D 精灵渲染和动画表现
## 阴影使用代码绘制的椭圆，无需纹理图片

# === 信号定义 ===
signal animation_completed(animation_name: String)
signal exit_completed()

# === 枚举定义 ===
# 方向索引：南=0, 东=1, 北=2, 西=3
enum Direction { SOUTH = 0, EAST = 1, NORTH = 2, WEST = 3 }

# 动画状态枚举
enum AnimationState {
	ENTER,
	TAKEOFF,
	IDLE,
	MOVE,
	ATTACK,
	HIT,
	LAND,
	DESTROY,
	EXIT
}

# === 常量定义 ===
const SPRITE_SIZE := 128
const SPRITES_PER_ROW := 8
const DIRECTION_COUNT := 4

# === 配置属性 ===
## 精灵表纹理资源
@export var sprite_sheet: Texture2D:
	set(value):
		sprite_sheet = value
		_update_sprites()
		_create_sprite_frames_if_needed()

## 机甲在精灵表中的索引（每行 8 台）
@export_range(0, 999) var unit_index: int = 0:
	set(value):
		if unit_index != value:
			unit_index = value
			_update_sprites()

## 当前朝向
@export var direction: Direction = Direction.SOUTH:
	set(value):
		direction = value
		_update_direction()

## 是否处于空中状态
@export var is_airborne: bool = false:
	set(value):
		is_airborne = value
		_update_airborne_visual()

## 是否处于禁用状态
@export var is_disabled: bool = false:
	set(value):
		is_disabled = value
		_update_disabled_visual()

## 空中状态机体 y 轴偏移量
@export var airborne_unit_offset: float = -20.0

## 阴影配置
@export_group("Shadow Settings")
## 是否自动根据机体大小计算阴影尺寸
@export var auto_shadow_size: bool = true:
	set(value):
		auto_shadow_size = value
		if auto_shadow_size:
			_update_shadow_size_from_sprite()

## 阴影宽度占机体宽度的比例
@export_range(0.1, 1.0) var shadow_width_ratio: float = 0.6:
	set(value):
		shadow_width_ratio = value
		if auto_shadow_size:
			_update_shadow_size_from_sprite()

## 阴影宽度（椭圆 x 方向半径，手动模式时使用）
@export var shadow_width: float = 32.0:
	set(value):
		shadow_width = value
		queue_redraw()

## 阴影高度（椭圆 y 方向半径，手动模式时使用）
@export var shadow_height: float = 16.0:
	set(value):
		shadow_height = value
		queue_redraw()

## 阴影基础 y 轴偏移量
@export var shadow_base_offset: float = 40.0

## 空中状态阴影 y 轴额外偏移量（向下）
@export var airborne_shadow_offset: float = 10.0

## 阴影透明度
@export_range(0.0, 1.0) var shadow_alpha: float = 0.5:
	set(value):
		shadow_alpha = value
		queue_redraw()

## 阴影颜色（RGB 部分，透明度由 shadow_alpha 控制）
@export var shadow_color: Color = Color(0.2, 0.2, 0.2):
	set(value):
		shadow_color = value
		queue_redraw()

## 动画帧速率
@export var animation_fps: float = 10.0

## === 动画参数配置 ===
@export_group("Animation Settings")

## 入场动画持续时间（秒）
@export_range(0.1, 2.0, 0.1) var enter_duration: float = 0.5

## 入场动画起始偏移量（像素）
@export_range(50.0, 300.0, 10.0) var enter_offset: float = 100.0

## 起飞动画持续时间（秒）
@export_range(0.1, 1.0, 0.1) var takeoff_duration: float = 0.3

## 起飞动画上升高度（像素）
@export_range(10.0, 50.0, 5.0) var takeoff_height: float = 20.0

## 攻击动画持续时间（秒）
@export_range(0.1, 1.0, 0.1) var attack_duration: float = 0.4

## 攻击动画冲锋距离（像素）
@export_range(10.0, 100.0, 5.0) var attack_charge_distance: float = 30.0

## 受击动画持续时间（秒）
@export_range(0.1, 1.0, 0.1) var hit_duration: float = 0.3

## 受击动画震动强度（像素）
@export_range(1.0, 20.0, 1.0) var hit_shake_intensity: float = 5.0

## 受击动画闪白颜色
@export var hit_flash_color: Color = Color.WHITE

## 降落动画持续时间（秒）
@export_range(0.1, 1.0, 0.1) var land_duration: float = 0.3

## 击毁动画持续时间（秒）
@export_range(0.3, 2.0, 0.1) var destroy_duration: float = 0.8

## 击毁动画闪烁次数
@export_range(2, 10) var destroy_flash_count: int = 4

## 击毁动画最终缩放比例
@export_range(0.0, 2.0, 0.1) var destroy_final_scale: float = 1.5

## 离场动画持续时间（秒）
@export_range(0.1, 2.0, 0.1) var exit_duration: float = 0.5

## 离场动画偏移量（像素）
@export_range(50.0, 300.0, 10.0) var exit_offset: float = 100.0

# === 动画状态变量 ===
var _current_animation: AnimationState = AnimationState.IDLE
var _sprite_frames_cache: SpriteFrames = null
## 缓存的机体边界框宽度
var _cached_unit_width: float = 0.0
## 当前活动的 Tween
var _current_tween: Tween = null
## 动画前的原始位置（用于恢复）
var _original_position: Vector2 = Vector2.ZERO
## 动画前的原始 modulate（用于恢复）
var _original_modulate: Color = Color.WHITE

# === 节点引用 ===
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# === 生命周期方法 ===
func _ready() -> void:
	if not Engine.is_editor_hint():
		_setup_animation_callbacks()
	_create_sprite_frames_if_needed()
	_update_sprites()
	_update_direction()
	_update_airborne_visual()
	_update_disabled_visual()
	queue_redraw()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		# 编辑器实时预览更新
		_update_sprites()
		_update_direction()
		_update_airborne_visual()
		_update_disabled_visual()

# === 阴影绘制 ===
func _draw() -> void:
	# 计算阴影位置（正下方光源，无方向偏移）
	var shadow_y: float = shadow_base_offset

	# 空中状态时阴影向下偏移
	if is_airborne:
		shadow_y += airborne_shadow_offset

	# 绘制 2:1 椭圆阴影（2.5D 等距视角）
	var shadow_center := Vector2(0, shadow_y)
	var final_color := Color(shadow_color.r, shadow_color.g, shadow_color.b, shadow_alpha)

	# 使用 draw_set_transform_matrix 设置椭圆变换（宽度/高度 = 2:1）
	var ellipse_transform := Transform2D.IDENTITY
	ellipse_transform = ellipse_transform.scaled(Vector2(shadow_width / shadow_height, 1.0))
	ellipse_transform.origin = shadow_center

	draw_set_transform_matrix(ellipse_transform)
	draw_circle(Vector2(0, 0), shadow_height, final_color)
	draw_set_transform_matrix(Transform2D.IDENTITY)

# === 阴影尺寸动态计算 ===
## 根据精灵图片计算阴影尺寸
func _update_shadow_size_from_sprite() -> void:
	if not sprite_sheet:
		return

	# 获取精灵图片数据
	var image: Image = sprite_sheet.get_image()
	if not image:
		return

	# 计算当前机甲在精灵表中的位置
	var row := unit_index / SPRITES_PER_ROW
	var col_start := (unit_index % SPRITES_PER_ROW) * DIRECTION_COUNT
	var x_pos := (col_start + direction) * SPRITE_SIZE
	var y_pos := row * SPRITE_SIZE

	# 分析该区域的非透明像素边界
	var bounds := _calculate_sprite_bounds(image, x_pos, y_pos)

	# 根据机体宽度计算阴影尺寸
	if bounds.width > 0:
		_cached_unit_width = bounds.width - 12
		# 阴影宽度 = 机体宽度 * 比例
		shadow_width = (bounds.width - 12) * shadow_width_ratio
		# 阴影高度保持 2:1 比例
		shadow_height = shadow_width / 2.0
		# 阴影 y 偏移 = 机体底部位置 + 基础偏移
		shadow_base_offset = 40 + 5.0

	queue_redraw()

## 分析精灵图片中非透明像素的边界框
func _calculate_sprite_bounds(image: Image, x_offset: int, y_offset: int) -> Dictionary:
	var min_x: int = SPRITE_SIZE
	var max_x: int = 0
	var min_y: int = SPRITE_SIZE
	var max_y: int = 0

	# 遍历精灵区域的像素
	for y in range(SPRITE_SIZE):
		for x in range(SPRITE_SIZE):
			var pixel_x := x_offset + x
			var pixel_y := y_offset + y

			# 确保像素坐标在图片范围内
			if pixel_x >= 0 and pixel_x < image.get_width():
				if pixel_y >= 0 and pixel_y < image.get_height():
					var pixel := image.get_pixel(pixel_x, pixel_y)
					# 检查像素是否非透明（alpha > 0.1）
					if pixel.a > 0.1:
						if x < min_x:
							min_x = x
						if x > max_x:
							max_x = x
						if y < min_y:
							min_y = y
						if y > max_y:
							max_y = y

	# 返回边界框信息
	var width: int = max_x - min_x + 1 if max_x >= min_x else 0
	var height: int = max_y - min_y + 1 if max_y >= min_y else 0

	return {
		"width": width,
		"height": height,
		"left": min_x,
		"right": max_x,
		"top": min_y,
		"bottom": max_y,
		"center_x": min_x + width / 2.0
	}

# === SpriteFrames 动态创建 ===
func _create_sprite_frames_if_needed() -> void:
	if not is_node_ready() or not sprite_sheet:
		return

	if animated_sprite and not animated_sprite.sprite_frames:
		animated_sprite.sprite_frames = _create_sprite_frames()

func _create_sprite_frames() -> SpriteFrames:
	if _sprite_frames_cache:
		return _sprite_frames_cache

	var frames := SpriteFrames.new()

	# 为每种动画状态和每个方向创建动画
	for state in AnimationState.values():
		for dir in Direction.values():
			var anim_name := _get_animation_name_for_direction_ex(state, dir)
			frames.add_animation(anim_name)

			# 获取该方向的纹理帧
			var atlas := _create_atlas_texture_for_unit(state, dir)
			frames.add_frame(anim_name, atlas)

			# 设置动画属性
			frames.set_animation_loop(anim_name, _is_loop_animation(state))
			frames.set_animation_speed(anim_name, animation_fps)

	_sprite_frames_cache = frames
	return frames

func _create_atlas_texture_for_unit(_state: AnimationState, dir: Direction) -> AtlasTexture:
	var atlas := AtlasTexture.new()
	atlas.atlas = sprite_sheet

	# 计算纹理位置
	# 精灵表布局：每行 8 台机体，每台机体 4 方向水平排列
	# row = unit_index / 8, col_start = (unit_index % 8) * 4
	# x = (col_start + direction) * 128, y = row * 128
	var row := unit_index / SPRITES_PER_ROW
	var col_start := (unit_index % SPRITES_PER_ROW) * DIRECTION_COUNT
	var x_pos := (col_start + dir) * SPRITE_SIZE
	var y_pos := row * SPRITE_SIZE

	atlas.region = Rect2(x_pos, y_pos, SPRITE_SIZE, SPRITE_SIZE)
	return atlas

func _get_animation_name_for_direction_ex(state: AnimationState, dir: Direction) -> String:
	var base_name: String = AnimationState.keys()[state].to_lower()
	return "%s_%s" % [base_name, Direction.keys()[dir].to_lower()]

# === 精灵表纹理处理 ===
func _update_sprites() -> void:
	if not is_node_ready() or not sprite_sheet:
		return

	# 计算机甲纹理位置
	# 精灵表布局：每行 8 台机体，每台机体 4 方向水平排列
	# row = unit_index / 8, col_start = (unit_index % 8) * 4
	# x = (col_start + direction) * 128, y = row * 128
	var row := unit_index / SPRITES_PER_ROW
	var col_start := (unit_index % SPRITES_PER_ROW) * DIRECTION_COUNT
	var x_pos := (col_start + direction) * SPRITE_SIZE
	var y_pos := row * SPRITE_SIZE

	# 创建 AtlasTexture
	var atlas := AtlasTexture.new()
	atlas.atlas = sprite_sheet
	atlas.region = Rect2(x_pos, y_pos, SPRITE_SIZE, SPRITE_SIZE)

	# 更新显示纹理
	if animated_sprite:
		# 如果已有 SpriteFrames，更新所有动画帧的纹理
		if animated_sprite.sprite_frames:
			_update_sprite_frames_textures()
		else:
			animated_sprite.texture = atlas

	# 自动计算阴影尺寸
	if auto_shadow_size:
		_update_shadow_size_from_sprite()

## 更新 SpriteFrames 中所有动画帧的纹理位置
func _update_sprite_frames_textures() -> void:
	if not animated_sprite or not animated_sprite.sprite_frames:
		return

	var frames := animated_sprite.sprite_frames

	# 遍历所有动画，更新每个帧的纹理 region
	for anim_name in frames.get_animation_names():
		var frame_count := frames.get_frame_count(anim_name)
		for frame_idx in range(frame_count):
			var texture := frames.get_frame_texture(anim_name, frame_idx)
			if texture is AtlasTexture and texture.atlas == sprite_sheet:
				# 解析动画名称获取方向 (如 "idle_south" → direction=SOUTH)
				var dir := _parse_direction_from_animation_name(anim_name)
				# 使用正确的精灵表布局计算
				var row := unit_index / SPRITES_PER_ROW
				var col_start := (unit_index % SPRITES_PER_ROW) * DIRECTION_COUNT
				var x_pos := (col_start + dir) * SPRITE_SIZE
				var y_pos := row * SPRITE_SIZE
				texture.region = Rect2(x_pos, y_pos, SPRITE_SIZE, SPRITE_SIZE)

## 从动画名称解析方向索引
func _parse_direction_from_animation_name(anim_name: String) -> int:
	var parts := anim_name.split("_")
	if parts.size() >= 2:
		var dir_name := parts[-1]  # 最后部分是方向
		for dir in Direction.values():
			if Direction.keys()[dir].to_lower() == dir_name:
				return dir
	return Direction.SOUTH

func _update_direction() -> void:
	if not is_node_ready():
		return
	_update_sprites()
	# 根据朝向选择对应的动画帧（如果 SpriteFrames 已配置）
	if animated_sprite and animated_sprite.sprite_frames:
		var anim_name := _get_animation_name_for_direction(_current_animation)
		if animated_sprite.sprite_frames.has_animation(anim_name):
			animated_sprite.play(anim_name)

func _get_animation_name_for_direction(state: AnimationState) -> String:
	var base_name: String = AnimationState.keys()[state].to_lower()
	return "%s_%s" % [base_name, Direction.keys()[direction].to_lower()]

# === 状态渲染处理 ===
func _update_airborne_visual() -> void:
	if not is_node_ready():
		return

	if animated_sprite:
		var target_y := airborne_unit_offset if is_airborne else 0.0
		animated_sprite.position.y = target_y

	# 重绘阴影
	queue_redraw()

func _update_disabled_visual() -> void:
	if not is_node_ready():
		return

	if animated_sprite:
		animated_sprite.modulate = Color.GRAY if is_disabled else Color.WHITE

# === Tween 动画管理 ===
## 停止当前活动的 Tween
func _stop_current_tween() -> void:
	if _current_tween and _current_tween.is_valid():
		_current_tween.kill()
		_current_tween = null

## 恢复动画前的状态
func _restore_animation_state() -> void:
	if animated_sprite:
		animated_sprite.position = _original_position
		animated_sprite.modulate = _original_modulate if not is_disabled else Color.GRAY
	queue_redraw()

## 创建并行 Tween
func _create_parallel_tween() -> Tween:
	_stop_current_tween()
	# 保存当前状态
	if animated_sprite:
		_original_position = animated_sprite.position
		_original_modulate = animated_sprite.modulate
	_current_tween = create_tween().set_parallel(true)
	return _current_tween

## 创建序列 Tween
func _create_sequence_tween() -> Tween:
	_stop_current_tween()
	# 保存当前状态
	if animated_sprite:
		_original_position = animated_sprite.position
		_original_modulate = animated_sprite.modulate
	_current_tween = create_tween().set_parallel(false)
	return _current_tween

# === 程序化动画实现 ===
## 入场动画：从边缘滑入 + 淡入
func _play_enter_animation() -> void:
	if Engine.is_editor_hint():
		return

	if not animated_sprite:
		return

	# 计算入场起始位置（基于当前朝向）
	var start_offset := _get_direction_offset()
	var target_pos := Vector2.ZERO

	# 设置初始状态：透明 + 偏移位置
	animated_sprite.modulate = Color.TRANSPARENT
	animated_sprite.position = target_pos + start_offset

	# 创建并行 Tween：位置动画 + 透明度动画
	var tween := _create_parallel_tween()
	tween.tween_property(animated_sprite, "position", target_pos, enter_duration)
	var target_modulate := Color.WHITE if not is_disabled else Color.GRAY
	tween.tween_property(animated_sprite, "modulate", target_modulate, enter_duration)
	tween.set_parallel(false)
	tween.tween_callback(_on_enter_animation_finished)

## 获取当前朝向对应的偏移向量
func _get_direction_offset() -> Vector2:
	match direction:
		Direction.SOUTH:
			return Vector2(0, enter_offset)  # 从下方入场
		Direction.EAST:
			return Vector2(-enter_offset, 0)  # 从左侧入场
		Direction.NORTH:
			return Vector2(0, -enter_offset)  # 从上方入场
		Direction.WEST:
			return Vector2(enter_offset, 0)  # 从右侧入场
	return Vector2(0, enter_offset)

## 入场动画完成回调
func _on_enter_animation_finished() -> void:
	_current_tween = null
	animation_completed.emit("enter")
	play_animation(AnimationState.IDLE)

## 起飞动画：机体上升 + 阴影分离
func _play_takeoff_animation() -> void:
	if Engine.is_editor_hint():
		is_airborne = true
		_update_airborne_visual()
		return

	if not animated_sprite:
		return

	# 目标位置：向上移动 takeoff_height
	var target_pos := Vector2(0, airborne_unit_offset - takeoff_height)

	# 创建序列 Tween
	var tween := _create_sequence_tween()

	# 上升动画
	tween.tween_property(animated_sprite, "position", target_pos, takeoff_duration)

	# 完成回调
	tween.tween_callback(_on_takeoff_animation_finished)

## 起飞动画完成回调
func _on_takeoff_animation_finished() -> void:
	_current_tween = null
	is_airborne = true
	# 恢复到正常 airborne 位置
	if animated_sprite:
		animated_sprite.position.y = airborne_unit_offset
	animation_completed.emit("takeoff")
	play_animation(AnimationState.IDLE)

## 攻击动画：冲锋 → 返回
func _play_attack_animation() -> void:
	if Engine.is_editor_hint():
		return

	if not animated_sprite:
		return

	# 计算冲锋方向偏移
	var charge_offset := _get_charge_direction_offset()

	# 当前位置（考虑 airborne 状态）
	var current_pos := Vector2(0, airborne_unit_offset if is_airborne else 0.0)
	# 冲锋目标位置
	var charge_pos := current_pos + charge_offset

	# 创建序列 Tween：冲锋 → 返回
	var tween := _create_sequence_tween()

	# 冲锋动画
	tween.tween_property(animated_sprite, "position", charge_pos, attack_duration / 2.0)

	# 返回动画
	tween.tween_property(animated_sprite, "position", current_pos, attack_duration / 2.0)

	# 完成回调
	tween.tween_callback(_on_attack_animation_finished)

## 获取冲锋方向偏移（基于当前朝向）
func _get_charge_direction_offset() -> Vector2:
	match direction:
		Direction.SOUTH:
			return Vector2(0, attack_charge_distance)  # 向下冲锋
		Direction.EAST:
			return Vector2(attack_charge_distance, 0)  # 向右冲锋
		Direction.NORTH:
			return Vector2(0, -attack_charge_distance)  # 向上冲锋
		Direction.WEST:
			return Vector2(-attack_charge_distance, 0)  # 向左冲锋
	return Vector2(0, attack_charge_distance)

## 攻击动画完成回调
func _on_attack_animation_finished() -> void:
	_current_tween = null
	animation_completed.emit("attack")
	play_animation(AnimationState.IDLE)

## 受击动画：闪白 + 震动
func _play_hit_animation() -> void:
	if Engine.is_editor_hint():
		return

	if not animated_sprite:
		return

	# 当前位置
	var current_pos := Vector2(0, airborne_unit_offset if is_airborne else 0.0)

	# 创建序列 Tween
	var tween := _create_sequence_tween()

	# 闪白动画
	tween.tween_property(animated_sprite, "modulate", hit_flash_color, hit_duration / 4.0)

	# 震动动画：左右来回震动
	var shake_time := hit_duration / 8.0
	var shake_right := current_pos.x + hit_shake_intensity
	var shake_left := current_pos.x - hit_shake_intensity
	tween.tween_property(animated_sprite, "position:x", shake_right, shake_time)
	tween.tween_property(animated_sprite, "position:x", shake_left, shake_time)
	tween.tween_property(animated_sprite, "position:x", shake_right, shake_time)
	tween.tween_property(animated_sprite, "position:x", shake_left, shake_time)

	# 恢复原色和位置
	var restore_modulate := Color.WHITE if not is_disabled else Color.GRAY
	tween.tween_property(animated_sprite, "modulate", restore_modulate, hit_duration / 4.0)
	tween.tween_property(animated_sprite, "position", current_pos, hit_duration / 4.0)

	# 完成回调
	tween.tween_callback(_on_hit_animation_finished)

## 受击动画完成回调
func _on_hit_animation_finished() -> void:
	_current_tween = null
	animation_completed.emit("hit")
	play_animation(AnimationState.IDLE)

## 降落动画：机体下降 + 阴影合并
func _play_land_animation() -> void:
	if Engine.is_editor_hint():
		is_airborne = false
		_update_airborne_visual()
		return

	if not animated_sprite:
		return

	# 当前位置（从 airborne 位置开始）
	var current_pos := Vector2(0, airborne_unit_offset)
	# 目标位置：地面位置
	var target_pos := Vector2.ZERO

	# 创建序列 Tween
	var tween := _create_sequence_tween()

	# 下降动画
	tween.tween_property(animated_sprite, "position", target_pos, land_duration)

	# 完成回调
	tween.tween_callback(_on_land_animation_finished)

## 降落动画完成回调
func _on_land_animation_finished() -> void:
	_current_tween = null
	is_airborne = false
	# 确保位置恢复到地面
	if animated_sprite:
		animated_sprite.position.y = 0.0
	queue_redraw()
	animation_completed.emit("land")
	play_animation(AnimationState.IDLE)

## 击毁动画：闪烁 + 缩放爆炸
func _play_destroy_animation() -> void:
	if Engine.is_editor_hint():
		return

	if not animated_sprite:
		return

	# 创建序列 Tween
	var tween := _create_sequence_tween()

	# 闪烁效果：来回切换颜色
	var flash_time := destroy_duration / (destroy_flash_count * 2.0)
	for i in destroy_flash_count:
		tween.tween_property(animated_sprite, "modulate", Color.RED, flash_time)
		tween.tween_property(animated_sprite, "modulate", Color.WHITE, flash_time)

	# 最后一次闪烁变红
	tween.tween_property(animated_sprite, "modulate", Color.RED, flash_time)

	# 缩放爆炸效果
	var scale_target := Vector2(destroy_final_scale, destroy_final_scale)
	var scale_time := destroy_duration / 4.0
	tween.tween_property(animated_sprite, "scale", scale_target, scale_time)

	# 淡出消失
	tween.tween_property(animated_sprite, "modulate:a", 0.0, destroy_duration / 4.0)

	# 完成回调
	tween.tween_callback(_on_destroy_animation_finished)

## 击毁动画完成回调
func _on_destroy_animation_finished() -> void:
	_current_tween = null
	# 保持消失状态，不恢复
	animation_completed.emit("destroy")
	# 击毁动画完成后不自动切换，发出 destroy 完成信号
	# 注意：destroy 动画结束后单位应该被移除，这里不做状态切换

## 离场动画：滑出 + 淡出
func _play_exit_animation() -> void:
	if Engine.is_editor_hint():
		return

	if not animated_sprite:
		return

	# 计算离场方向偏移（与入场相反）
	var exit_direction := _get_exit_direction_offset()
	var target_pos := exit_direction

	# 当前位置（考虑 airborne 状态）
	var current_pos := Vector2(0, airborne_unit_offset if is_airborne else 0.0)
	target_pos += current_pos

	# 创建并行 Tween：位置动画 + 透明度动画
	var tween := _create_parallel_tween()
	tween.tween_property(animated_sprite, "position", target_pos, exit_duration)
	tween.tween_property(animated_sprite, "modulate:a", 0.0, exit_duration)
	tween.set_parallel(false)

	# 完成回调
	tween.tween_callback(_on_exit_animation_finished)

## 获取离场方向偏移（与入场相反）
func _get_exit_direction_offset() -> Vector2:
	match direction:
		Direction.SOUTH:
			return Vector2(0, exit_offset)  # 向下方离场
		Direction.EAST:
			return Vector2(exit_offset, 0)  # 向右侧离场
		Direction.NORTH:
			return Vector2(0, -exit_offset)  # 向上方离场
		Direction.WEST:
			return Vector2(-exit_offset, 0)  # 向左侧离场
	return Vector2(0, exit_offset)

## 离场动画完成回调
func _on_exit_animation_finished() -> void:
	_current_tween = null
	# 发出离场完成信号
	exit_completed.emit()

# === 动画状态管理 ===
func _setup_animation_callbacks() -> void:
	if animated_sprite:
		animated_sprite.animation_finished.connect(_on_animation_finished)

func _on_animation_finished() -> void:
	# 程序化动画有自己的完成回调，这里只处理 SpriteFrames 动画
	var procedural_states := [
		AnimationState.ENTER, AnimationState.TAKEOFF, AnimationState.LAND,
		AnimationState.ATTACK, AnimationState.HIT,
		AnimationState.DESTROY, AnimationState.EXIT
	]
	if _current_animation in procedural_states:
		return

	var anim_name: String = AnimationState.keys()[_current_animation].to_lower()

	# 发出动画完成信号
	animation_completed.emit(anim_name)

	# SpriteFrames 动画完成处理（idle/move 是循环动画，无需处理）
	# 其他非循环动画完成后返回 idle
	if not _is_loop_animation(_current_animation):
		play_animation(AnimationState.IDLE)

func _is_loop_animation(state: AnimationState) -> bool:
	return state in [AnimationState.IDLE, AnimationState.MOVE]

func play_animation(state: AnimationState) -> void:
	_current_animation = state

	if not animated_sprite:
		return

	# 停止当前 Tween 动画
	_stop_current_tween()

	# 程序化动画触发
	if _try_play_procedural_animation(state):
		return

	# 其他状态使用 SpriteFrames 动画
	if animated_sprite.sprite_frames:
		var anim_name := _get_animation_name_for_direction(state)

		if animated_sprite.sprite_frames.has_animation(anim_name):
			animated_sprite.play(anim_name)
		else:
			# 如果没有方向特定的动画，尝试播放基础动画名
			var base_name: String = AnimationState.keys()[state].to_lower()
			if animated_sprite.sprite_frames.has_animation(base_name):
				animated_sprite.play(base_name)

## 尝试播放程序化动画，返回 true 表示已处理
func _try_play_procedural_animation(state: AnimationState) -> bool:
	if Engine.is_editor_hint():
		return false

	match state:
		AnimationState.ENTER:
			_play_enter_animation()
		AnimationState.TAKEOFF:
			_play_takeoff_animation()
		AnimationState.LAND:
			_play_land_animation()
		AnimationState.ATTACK:
			_play_attack_animation()
		AnimationState.HIT:
			_play_hit_animation()
		AnimationState.DESTROY:
			_play_destroy_animation()
		AnimationState.EXIT:
			_play_exit_animation()
		_:
			return false
	return true

# === 状态同步接口 ===
## 连接到 UnitInstance 的信号
func connect_to_unit_instance(unit_instance: Node) -> void:
	if not unit_instance:
		return

	# 连接所有状态同步信号
	if unit_instance.has_signal("deployed"):
		unit_instance.deployed.connect(_on_deployed)
	if unit_instance.has_signal("airborne_changed"):
		unit_instance.airborne_changed.connect(_on_airborne_changed)
	if unit_instance.has_signal("action_started"):
		unit_instance.action_started.connect(_on_action_started_signal)
	if unit_instance.has_signal("action_completed"):
		unit_instance.action_completed.connect(_on_action_completed_signal)
	if unit_instance.has_signal("hit_received"):
		unit_instance.hit_received.connect(_on_hit_received)
	if unit_instance.has_signal("destroyed"):
		unit_instance.destroyed.connect(_on_destroyed)
	if unit_instance.has_signal("disabled_changed"):
		unit_instance.disabled_changed.connect(_on_disabled_changed)
	if unit_instance.has_signal("exiting"):
		unit_instance.exiting.connect(_on_exiting)

## 断开与 UnitInstance 的信号连接
func disconnect_from_unit_instance(unit_instance: Node) -> void:
	if not unit_instance:
		return

	if unit_instance.has_signal("deployed"):
		unit_instance.deployed.disconnect(_on_deployed)
	if unit_instance.has_signal("airborne_changed"):
		unit_instance.airborne_changed.disconnect(_on_airborne_changed)
	if unit_instance.has_signal("action_started"):
		unit_instance.action_started.disconnect(_on_action_started_signal)
	if unit_instance.has_signal("action_completed"):
		unit_instance.action_completed.disconnect(_on_action_completed_signal)
	if unit_instance.has_signal("hit_received"):
		unit_instance.hit_received.disconnect(_on_hit_received)
	if unit_instance.has_signal("destroyed"):
		unit_instance.destroyed.disconnect(_on_destroyed)
	if unit_instance.has_signal("disabled_changed"):
		unit_instance.disabled_changed.disconnect(_on_disabled_changed)
	if unit_instance.has_signal("exiting"):
		unit_instance.exiting.disconnect(_on_exiting)

# === 信号处理方法 ===
func _on_deployed() -> void:
	play_animation(AnimationState.ENTER)

func _on_airborne_changed(value: bool) -> void:
	if value and not is_airborne:
		play_animation(AnimationState.TAKEOFF)
	elif not value and is_airborne:
		play_animation(AnimationState.LAND)

func _on_action_started_signal(action_type: String) -> void:
	match action_type:
		"move":
			play_animation(AnimationState.MOVE)
		"attack":
			play_animation(AnimationState.ATTACK)
		_:
			play_animation(AnimationState.IDLE)

func _on_action_completed_signal() -> void:
	play_animation(AnimationState.IDLE)

func _on_hit_received() -> void:
	play_animation(AnimationState.HIT)

func _on_destroyed() -> void:
	play_animation(AnimationState.DESTROY)

func _on_disabled_changed(value: bool) -> void:
	is_disabled = value

func _on_exiting() -> void:
	play_animation(AnimationState.EXIT)

# === 公开接口方法 ===
## 设置朝向方向
func set_direction(dir: Direction) -> void:
	direction = dir

## 设置空中状态（由外部信号触发）
func set_airborne(value: bool) -> void:
	if value and not is_airborne:
		play_animation(AnimationState.TAKEOFF)
	elif not value and is_airborne:
		play_animation(AnimationState.LAND)

## 设置禁用状态（由外部信号触发）
func set_disabled(value: bool) -> void:
	is_disabled = value

## 部署单位（播放入场动画）
func deploy() -> void:
	play_animation(AnimationState.ENTER)

## 单位离场（播放离场动画）
func exit_unit() -> void:
	play_animation(AnimationState.EXIT)

## 单位击毁（播放击毁动画）
func destroy_unit() -> void:
	play_animation(AnimationState.DESTROY)

## 单位受击（播放受击动画）
func hit() -> void:
	play_animation(AnimationState.HIT)

## 开始行动（由 action_started 信号触发）
func on_action_started(action_type: String) -> void:
	match action_type:
		"move":
			play_animation(AnimationState.MOVE)
		"attack":
			play_animation(AnimationState.ATTACK)
		_:
			play_animation(AnimationState.IDLE)

## 行动完成（由 action_completed 信号触发）
func on_action_completed() -> void:
	play_animation(AnimationState.IDLE)
