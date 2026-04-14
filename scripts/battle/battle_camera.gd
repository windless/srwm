## BattleCamera
## 战斗场景相机控制器
## 支持移动端触控操作：单指平移、双指缩放、网格选择

class_name BattleCamera
extends Camera2D

## 信号：网格格子被选中
signal grid_cell_selected(coord: GridCoord)

## 最小缩放级别
@export var min_zoom: float = 0.5

## 最大缩放级别
@export var max_zoom: float = 2.0

## 平移速度系数（影响拖拽灵敏度）
@export var pan_speed: float = 1.0

## GridMapSystem 引用（用于获取地图边界和坐标转换）
@export var grid_map_system: Node

## TileMapLayer 引用（用于坐标转换）
@export var tile_layer: TileMapLayer

## 网格单元格尺寸（用于坐标转换）
@export var cell_size: Vector2 = Vector2(64, 32)

## 触摸选择容差（像素）
@export var touch_tolerance: float = 16.0

## 聚焦动画持续时间
@export var focus_duration: float = 0.3

## 当前拖拽状态
var _is_dragging: bool = false

## 上一次触摸位置（用于计算拖拽增量）
var _last_touch_pos: Vector2 = Vector2.ZERO

## 是否正在双指缩放
var _is_pinching: bool = false

## 聚焦动画 Tween
var _focus_tween: Tween


func _ready() -> void:
	# 确保相机在场景树中启用
	make_current()


func _input(event: InputEvent) -> void:
	# 处理触摸拖拽平移
	if event is InputEventScreenDrag:
		_handle_drag(event)
	# 处理触摸开始
	elif event is InputEventScreenTouch:
		_handle_touch(event)
	# 处理双指缩放（Godot 4.x 使用 InputEventMagnifyGesture）
	elif event is InputEventMagnifyGesture:
		_handle_magnify(event)


## 处理单指拖拽
func _handle_drag(event: InputEventScreenDrag) -> void:
	# 如果正在双指缩放，忽略单指拖拽
	if _is_pinching:
		return

	# 第一次拖拽开始
	if not _is_dragging:
		_is_dragging = true
		_last_touch_pos = event.position
		return

	# 计算拖拽增量（反向移动相机）
	var delta: Vector2 = _last_touch_pos - event.position
	delta *= pan_speed

	# 更新相机位置
	position += delta

	# 应用边界限制
	_apply_bounds()

	# 更新上次位置
	_last_touch_pos = event.position


## 处理触摸事件
func _handle_touch(event: InputEventScreenTouch) -> void:
	# 触摸结束
	if not event.pressed:
		_is_dragging = false
		_is_pinching = false
		return

	# 单指触摸：检测网格选择
	if event.index == 0 and not _is_pinching:
		# 短暂触摸（非拖拽）视为选择
		if not _is_dragging:
			_detect_grid_selection(event.position)


## 处理双指缩放手势
func _handle_magnify(event: InputEventMagnifyGesture) -> void:
	_is_pinching = true

	# 根据缩放因子调整相机缩放
	var new_zoom: float = zoom.x * event.factor

	# 应用缩放限制
	new_zoom = clampf(new_zoom, min_zoom, max_zoom)

	# 更新缩放值
	zoom = Vector2(new_zoom, new_zoom)


## 应用相机边界限制
func _apply_bounds() -> void:
	if grid_map_system == null:
		return

	var bounds: Vector2i = grid_map_system.get_bounds()
	if bounds == Vector2i.ZERO:
		return

	# 计算地图的屏幕边界
	# 左上角 (0, 0) 和 右下角 (width-1, height-1)
	var min_screen: Vector2 = GridCoord.new(0, 0).to_screen(cell_size)
	var max_screen: Vector2 = GridCoord.new(bounds.x - 1, bounds.y - 1).to_screen(cell_size)

	# 考虑相机视口大小
	var viewport_size: Vector2 = get_viewport_rect().size / zoom.x

	# 计算相机可移动范围
	var min_cam: Vector2 = min_screen
	var max_cam: Vector2 = max_screen - viewport_size / 2.0 + cell_size

	# 边界限制
	position.x = clampf(position.x, min_cam.x, max_cam.x)
	position.y = clampf(position.y, min_cam.y, max_cam.y)


## 检测网格选择
func _detect_grid_selection(screen_pos: Vector2) -> void:
	var coord: GridCoord

	# 使用 TileMapLayer 或 GridCoord 进行坐标转换
	if tile_layer != null:
		# 转换到 TileMapLayer 本地坐标
		var local_pos: Vector2 = tile_layer.to_local(screen_pos)
		var map_pos: Vector2i = tile_layer.local_to_map(local_pos)
		coord = GridCoord.from_vector2i(map_pos)
	else:
		# 直接使用 GridCoord 转换
		coord = GridCoord.from_screen(screen_pos - position, cell_size)

	# 验证坐标是否在地图范围内
	if grid_map_system != null:
		if grid_map_system.is_valid_coord(coord):
			emit_signal("grid_cell_selected", coord)


## 聚焦到指定位置（平滑动画）
func focus_on_position(target_pos: Vector2) -> void:
	# 取消之前的动画
	if _focus_tween != null:
		_focus_tween.kill()

	# 创建新的 Tween
	_focus_tween = create_tween()
	_focus_tween.set_ease(Tween.EASE_OUT)
	_focus_tween.set_trans(Tween.TRANS_QUAD)

	# 动画到目标位置
	_focus_tween.tween_property(self, "position", target_pos, focus_duration)

	# 动画结束后应用边界
	_focus_tween.tween_callback(_apply_bounds)


## 聚焦到指定网格坐标
func focus_on_grid_coord(coord: GridCoord) -> void:
	var screen_pos: Vector2

	if tile_layer != null:
		screen_pos = tile_layer.map_to_local(coord.to_vector2i())
	else:
		screen_pos = coord.to_screen(cell_size)

	focus_on_position(screen_pos)


## 获取当前相机中心对应的网格坐标
func get_current_grid_coord() -> GridCoord:
	if tile_layer != null:
		var local_pos: Vector2 = tile_layer.to_local(get_viewport_rect().size / 2.0)
		var map_pos: Vector2i = tile_layer.local_to_map(local_pos)
		return GridCoord.from_vector2i(map_pos)
	return GridCoord.from_screen(get_viewport_rect().size / 2.0, cell_size)
