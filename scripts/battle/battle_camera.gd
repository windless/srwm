## BattleCamera
## 战斗场景相机控制器
## 支持移动端触控操作和桌面端鼠标操作：平移、缩放、网格选择

class_name BattleCamera
extends Camera2D

## 信号：网格格子被选中（旧信号，保留兼容）
signal grid_cell_selected(coord: GridCoord)

## 信号：光标移动（触摸/鼠标开始时）
signal cursor_moved(coord: GridCoord)

## 信号：光标确认（短触/短点击释放时）
signal cursor_confirmed(coord: GridCoord)

## 最小缩放级别
@export var min_zoom: float = 0.5

## 最大缩放级别
@export var max_zoom: float = 2.0

## 平移速度系数（影响拖拽灵敏度）
@export var pan_speed: float = 1.0

## 平移平滑系数（用于平滑拖拽）
@export var smoothing_enabled: bool = false

## GridMapSystem 引用（用于获取地图边界和坐标转换）
@export var grid_map_system: GridMapSystem

## TileMapLayer 引用（用于坐标转换）
@export var tile_layer: TileMapLayer

## 网格单元格尺寸（用于坐标转换）
@export var cell_size: Vector2 = Vector2(64, 32)

## 触摸选择容差（像素）
@export var touch_tolerance: float = 16.0

## 聚焦动画持续时间
@export var focus_duration: float = 0.3

## 短触/短点击确认最大时长（毫秒）
@export var tap_max_duration: float = 300.0

## 拖拽判定最小移动距离（像素）
@export var drag_threshold: float = 10.0

## 滚轮缩放步长
@export var zoom_step: float = 0.1

## 当前拖拽状态
var _is_dragging: bool = false

## 上一次触摸/鼠标位置（用于计算拖拽增量）
var _last_input_pos: Vector2 = Vector2.ZERO

## 是否正在双指缩放
var _is_pinching: bool = false

## 输入开始时间（用于判断短触/短点击）
var _input_start_time: float = 0.0

## 输入开始位置
var _input_start_pos: Vector2 = Vector2.ZERO

## 鼠标左键是否按下
var _mouse_pressed: bool = false

## 上一次发射的坐标（避免重复发射）
var _last_cursor_coord: GridCoord = null

## 聚焦动画 Tween
var _focus_tween: Tween


func _ready() -> void:
	# 确保相机在场景树中启用
	make_current()

	# 验证引用
	if grid_map_system == null:
		# 尝试从 NodePath 获取节点
		var path_node = get_node_or_null("../GridMapSystem")
		if path_node != null:
			grid_map_system = path_node as GridMapSystem


func _input(event: InputEvent) -> void:
	# 处理触摸事件
	if event is InputEventScreenDrag:
		_handle_touch_drag(event)
	elif event is InputEventScreenTouch:
		_handle_touch(event)
	elif event is InputEventMagnifyGesture:
		_handle_magnify(event)

	# 处理鼠标事件（桌面端）
	elif event is InputEventMouseButton:
		_handle_mouse_button(event)
	elif event is InputEventMouseMotion:
		_handle_mouse_motion(event)


## 处理触摸拖拽
func _handle_touch_drag(event: InputEventScreenDrag) -> void:
	# 如果正在双指缩放，忽略单指拖拽
	if _is_pinching:
		return

	# 检查是否超过拖拽阈值
	var move_distance: float = event.position.distance_to(_input_start_pos)
	if move_distance > drag_threshold:
		_is_dragging = true

	# 第一次拖拽开始
	if not _is_dragging:
		_last_input_pos = event.position
		return

	# 计算拖拽增量（反向移动相机，考虑缩放）
	var delta: Vector2 = (_last_input_pos - event.position) / zoom.x
	delta *= pan_speed

	# 更新相机位置
	position += delta

	# 更新上次位置
	_last_input_pos = event.position


## 处理触摸事件
func _handle_touch(event: InputEventScreenTouch) -> void:
	# 触摸结束
	if not event.pressed:
		# 检查是否为短触确认（非拖拽、短时长）
		if not _is_dragging and not _is_pinching:
			var touch_duration: float = Time.get_ticks_msec() - _input_start_time
			if touch_duration < tap_max_duration:
				_emit_cursor_confirmed(event.position)

		_is_dragging = false
		_is_pinching = false
		return

	# 触摸开始：记录时间和位置
	_input_start_time = Time.get_ticks_msec()
	_input_start_pos = event.position
	_last_input_pos = event.position

	# 单指触摸：发射光标移动信号
	if event.index == 0:
		_emit_cursor_moved(event.position)


## 处理双指缩放手势
func _handle_magnify(event: InputEventMagnifyGesture) -> void:
	_is_pinching = true

	# 根据缩放因子调整相机缩放
	var new_zoom: float = zoom.x * event.factor

	# 应用缩放限制
	new_zoom = clampf(new_zoom, min_zoom, max_zoom)

	# 更新缩放值
	zoom = Vector2(new_zoom, new_zoom)


## 处理鼠标按钮事件（桌面端）
func _handle_mouse_button(event: InputEventMouseButton) -> void:
	# 左键按下
	if event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# 记录开始时间和位置
			_input_start_time = Time.get_ticks_msec()
			_input_start_pos = event.position
			_last_input_pos = event.position
			_mouse_pressed = true

			# 发射光标移动信号
			_emit_cursor_moved(event.position)
		else:
			# 左键释放
			_mouse_pressed = false

			# 检查是否为短点击确认（非拖拽）
			if not _is_dragging:
				var click_duration: float = Time.get_ticks_msec() - _input_start_time
				if click_duration < tap_max_duration:
					_emit_cursor_confirmed(event.position)

			_is_dragging = false

	# 滚轮缩放
	elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
		_zoom_in()
	elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		_zoom_out()


## 处理鼠标移动事件（桌面端）
func _handle_mouse_motion(event: InputEventMouseMotion) -> void:
	# 如果鼠标左键按下
	if _mouse_pressed:
		# 检查是否超过拖拽阈值
		var move_distance: float = event.position.distance_to(_input_start_pos)
		if move_distance > drag_threshold:
			_is_dragging = true

		# 拖拽时更新相机位置
		if _is_dragging:
			# 计算拖拽增量（反向移动相机）
			# 考虑缩放级别：缩放越小（zoom越小），世界坐标移动越大
			var delta: Vector2 = (_last_input_pos - event.position) / zoom.x
			delta *= pan_speed

			# 更新相机位置
			position += delta

		# 更新上次位置
		_last_input_pos = event.position

	# 鼠标悬停时更新光标位置（只在非按下时）
	elif not _mouse_pressed:
		# 悬停时发射光标移动信号（实时跟踪）
		_emit_cursor_moved(event.position)


## 缩放放大
func _zoom_in() -> void:
	var new_zoom: float = zoom.x + zoom_step
	new_zoom = clampf(new_zoom, min_zoom, max_zoom)
	zoom = Vector2(new_zoom, new_zoom)


## 缩放缩小
func _zoom_out() -> void:
	var new_zoom: float = zoom.x - zoom_step
	new_zoom = clampf(new_zoom, min_zoom, max_zoom)
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


## 发射光标移动信号（只在坐标变化时发射）
func _emit_cursor_moved(screen_pos: Vector2) -> void:
	var coord: GridCoord = _get_coord_from_screen(screen_pos)

	if grid_map_system != null:
		if grid_map_system.is_valid_coord(coord):
			# 只在坐标变化时发射信号
			if _last_cursor_coord == null or not coord.equals(_last_cursor_coord):
				_last_cursor_coord = coord
				emit_signal("cursor_moved", coord)


## 发射光标确认信号
func _emit_cursor_confirmed(screen_pos: Vector2) -> void:
	var coord: GridCoord = _get_coord_from_screen(screen_pos)

	if grid_map_system != null:
		if grid_map_system.is_valid_coord(coord):
			emit_signal("cursor_confirmed", coord)
			# 同时发射旧信号保持兼容
			emit_signal("grid_cell_selected", coord)


## 从屏幕坐标获取网格坐标
func _get_coord_from_screen(screen_pos: Vector2) -> GridCoord:
	if tile_layer != null:
		var local_pos: Vector2 = tile_layer.to_local(screen_pos)
		var map_pos: Vector2i = tile_layer.local_to_map(local_pos)
		return GridCoord.from_vector2i(map_pos)
	return GridCoord.from_screen(screen_pos - position, cell_size)


## 检测网格选择（旧方法，保留兼容）
func _detect_grid_selection(screen_pos: Vector2) -> void:
	var coord: GridCoord = _get_coord_from_screen(screen_pos)

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
