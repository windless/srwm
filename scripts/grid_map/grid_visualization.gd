## GridVisualization
## 网格可视化组件，绘制网格线和网格高亮
## 支持 @tool 模式在编辑器中实时预览

@tool
class_name GridVisualization
extends Node2D

## 是否显示网格线
@export var show_grid_lines: bool = true:
	set(value):
		show_grid_lines = value
		queue_redraw()

## 网格线颜色
@export var grid_line_color: Color = Color(0.5, 0.5, 0.5, 0.5):
	set(value):
		grid_line_color = value
		queue_redraw()

## 网格线宽度
@export_range(1.0, 3.0) var grid_line_width: float = 1.0:
	set(value):
		grid_line_width = value
		queue_redraw()

## 网格单元格尺寸（Isometric 斜视角）
## 应与 TileMapLayer 的 TileSet.tile_size 保持一致
## 常用配置: Vector2(64, 32) 或 Vector2(128, 64)
@export var cell_size: Vector2 = Vector2(64, 32):
	set(value):
		cell_size = value
		queue_redraw()

## 地图宽度（网格数量）
@export var map_width: int = 10:
	set(value):
		map_width = value
		queue_redraw()

## 地图高度（网格数量）
@export var map_height: int = 10:
	set(value):
		map_height = value
		queue_redraw()

## 高亮填充颜色
@export var highlight_fill_color: Color = Color(0.2, 0.8, 0.2, 0.3):
	set(value):
		highlight_fill_color = value
		queue_redraw()

## 高亮边框颜色
@export var highlight_border_color: Color = Color(0.2, 0.8, 0.2, 0.8):
	set(value):
		highlight_border_color = value
		queue_redraw()

## 高亮网格列表
var _highlighted_coords: Array = []


## 绘制方法
func _draw() -> void:
	if show_grid_lines:
		draw_grid_lines()

	if _highlighted_coords.size() > 0:
		draw_highlights()


## 绘制网格线
func draw_grid_lines() -> void:
	var half_width: float = cell_size.x / 2.0
	var half_height: float = cell_size.y / 2.0

	# 绘制斜视角网格线 - 每行绘制横向线
	for row in range(map_height + 1):
		var start_x: float = -row * half_width
		var start_y: float = row * half_height
		var end_x: float = (map_width - row) * half_width
		var end_y: float = (map_width + row) * half_height
		draw_line(
			Vector2(start_x, start_y),
			Vector2(end_x, end_y),
			grid_line_color,
			grid_line_width
		)

	# 每列绘制纵向线
	for col in range(map_width + 1):
		var start_x: float = col * half_width
		var start_y: float = col * half_height
		var end_x: float = (col - map_height) * half_width
		var end_y: float = (col + map_height) * half_height
		draw_line(
			Vector2(start_x, start_y),
			Vector2(end_x, end_y),
			grid_line_color,
			grid_line_width
		)


## 绘制高亮网格
func draw_highlights() -> void:
	for coord in _highlighted_coords:
		if coord is GridCoord:
			draw_highlight_cell(coord)


## 绘制单个高亮网格
func draw_highlight_cell(coord: GridCoord) -> void:
	var screen_pos: Vector2 = coord.to_screen(cell_size)
	var half_width: float = cell_size.x / 2.0
	var half_height: float = cell_size.y / 2.0

	# 绘制斜视角菱形高亮
	var points: PackedVector2Array = PackedVector2Array([
		Vector2(screen_pos.x, screen_pos.y - half_height),  # 上
		Vector2(screen_pos.x + half_width, screen_pos.y),   # 右
		Vector2(screen_pos.x, screen_pos.y + half_height),  # 下
		Vector2(screen_pos.x - half_width, screen_pos.y),   # 左
	])

	# 填充
	draw_colored_polygon(points, highlight_fill_color)

	# 边框
	for i in range(4):
		draw_line(
			points[i],
			points[(i + 1) % 4],
			highlight_border_color,
			grid_line_width + 0.5
		)


## 设置高亮网格列表
func set_highlighted_coords(coords: Array) -> void:
	_highlighted_coords = coords
	queue_redraw()


## 添加单个高亮网格
func add_highlight(coord: GridCoord) -> void:
	if not _highlighted_coords.has(coord):
		_highlighted_coords.append(coord)
		queue_redraw()


## 清除所有高亮
func clear_highlights() -> void:
	_highlighted_coords.clear()
	queue_redraw()


## 清理资源（用于测试或场景卸载）
func cleanup() -> void:
	clear_highlights()


## 设置地图尺寸（与 GridMapSystem 同步）
func set_map_size(new_width: int, new_height: int) -> void:
	map_width = new_width
	map_height = new_height
	queue_redraw()