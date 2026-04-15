## GridCursor
## 网格光标组件，在地图上渲染选中格子的边框高亮指示器
## 使用 Line2D 绘制等距投影格子的菱形边框

class_name GridCursor
extends Node2D

## GridMapSystem 引用（用于坐标转换）
@export var grid_map_system: GridMapSystem

## 边框颜色（默认选中状态）
@export var border_color: Color = Color(0.2, 0.8, 1.0, 0.8)

## 确认状态边框颜色
@export var confirmed_color: Color = Color(1.0, 0.9, 0.2, 0.9)

## 边框宽度
@export var border_width: float = 3.0

## 位置动画持续时间
@export var animation_duration: float = 0.2

## 网格单元格尺寸（用于等距投影转换）
@export var cell_size: Vector2 = Vector2(128, 64)

## 当前光标坐标
var _current_coord: GridCoord = null

## 是否处于确认状态
var _is_confirmed: bool = false

## 边框线条节点
var _border_lines: Array[Line2D] = []

## 位置动画 Tween
var _position_tween: Tween


func _ready() -> void:
	_create_border_lines()
	hide()


## 创建边框线条（4条线组成等距投影菱形）
func _create_border_lines() -> void:
	# 检查是否已有边框线条（从场景实例化）
	var existing_lines: Array[Line2D] = []
	for child in get_children():
		if child is Line2D:
			existing_lines.append(child)

	# 如果已有 4 条线，直接使用
	if existing_lines.size() == 4:
		_border_lines.clear()
		for line in existing_lines:
			line.width = border_width
			line.default_color = border_color
			line.z_index = 10
			_border_lines.append(line)
		return

	# 否则清除已有线条并创建新的
	for line in _border_lines:
		if is_instance_valid(line):
			line.queue_free()
	_border_lines.clear()

	# 创建 4 条 Line2D 用于绘制菱形边框
	for i in range(4):
		var line: Line2D = Line2D.new()
		line.width = border_width
		line.default_color = border_color
		line.z_index = 10  # 确保在地图上方
		add_child(line)
		_border_lines.append(line)


## 更新边框线条颜色
func _update_border_color(color: Color) -> void:
	for line in _border_lines:
		if is_instance_valid(line):
			line.default_color = color


## 设置光标坐标
## coord: GridCoord 目标坐标，null 表示隐藏光标
func set_coord(coord: GridCoord) -> void:
	if coord == null:
		hide()
		_current_coord = null
		return

	# 检查坐标有效性
	if grid_map_system != null:
		if not grid_map_system.is_valid_coord(coord):
			hide()
			_current_coord = null
			return

	_current_coord = coord

	# 使用 TileMapLayer 直接计算格子中心的世界坐标
	var world_pos: Vector2 = _get_cell_center_world_position(coord)
	position = world_pos

	# 更新边框顶点
	_update_border_vertices(position)

	# 显示光标
	show()


## 获取格子中心的世界坐标
func _get_cell_center_world_position(coord: GridCoord) -> Vector2:
	if grid_map_system != null and grid_map_system.tile_layer != null:
		# TileMapLayer.map_to_local 返回格子中心的本地坐标
		# TileMapLayer.to_global 转换为世界坐标
		var local_pos: Vector2 = grid_map_system.tile_layer.map_to_local(Vector2i(coord.x, coord.y))
		return grid_map_system.tile_layer.to_global(local_pos)

	# 回退：使用 GridCoord.to_screen
	return coord.to_screen(cell_size)


## 获取坐标对应的屏幕位置
func _get_screen_position(coord: GridCoord) -> Vector2:
	if grid_map_system != null:
		return grid_map_system.get_screen_from_coord(coord)
	return coord.to_screen(cell_size)


## 平滑动画到目标位置（光标跟踪不需要动画，直接移动）
func _animate_to_position(target_pos: Vector2) -> void:
	# 光标跟踪鼠标时不需要平滑动画，直接设置位置
	position = target_pos


## 更新边框顶点（绘制等距投影菱形）
## 边框线条使用本地坐标，相对于 GridCursor.position
func _update_border_vertices(_center: Vector2) -> void:
	# 等距投影菱形的 4 个顶点（相对于格子中心）
	# 本地坐标系以格子中心为原点
	var half_width: float = cell_size.x / 2.0
	var half_height: float = cell_size.y / 2.0

	# 4 条边框线（本地坐标）
	# Line 0: top (0, -half_height) -> right (half_width, 0)
	# Line 1: right (half_width, 0) -> bottom (0, half_height)
	# Line 2: bottom (0, half_height) -> left (-half_width, 0)
	# Line 3: left (-half_width, 0) -> top (0, -half_height)
	if _border_lines.size() >= 4:
		_border_lines[0].clear_points()
		_border_lines[0].add_point(Vector2(0, -half_height))  # top
		_border_lines[0].add_point(Vector2(half_width, 0))    # right

		_border_lines[1].clear_points()
		_border_lines[1].add_point(Vector2(half_width, 0))    # right
		_border_lines[1].add_point(Vector2(0, half_height))   # bottom

		_border_lines[2].clear_points()
		_border_lines[2].add_point(Vector2(0, half_height))   # bottom
		_border_lines[2].add_point(Vector2(-half_width, 0))   # left

		_border_lines[3].clear_points()
		_border_lines[3].add_point(Vector2(-half_width, 0))   # left
		_border_lines[3].add_point(Vector2(0, -half_height))  # top


## 设置确认状态（改变边框颜色）
func set_confirmed_state(confirmed: bool) -> void:
	_is_confirmed = confirmed

	var target_color: Color = border_color if not confirmed else confirmed_color
	_update_border_color(target_color)


## 获取当前坐标
func get_current_coord() -> GridCoord:
	return _current_coord


## 隐藏光标
func hide_cursor() -> void:
	hide()
	_current_coord = null
	_is_confirmed = false