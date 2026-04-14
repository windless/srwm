## GridVisualization 单元测试
## 测试网格线绘制、高亮功能

class_name TestGridVisualization
extends GutTest


var _visualization: GridVisualization


func before_each() -> void:
	_visualization = GridVisualization.new()
	_visualization.map_width = 5
	_visualization.map_height = 5
	_visualization.cell_size = Vector2(64, 32)


func after_each() -> void:
	if _visualization != null:
		_visualization.cleanup()
		_visualization.free()
		_visualization = null


func test_default_show_grid_lines() -> void:
	assert_true(_visualization.show_grid_lines, "default show_grid_lines should be true")


func test_default_grid_line_color() -> void:
	var expected := Color(0.5, 0.5, 0.5, 0.5)
	assert_eq(_visualization.grid_line_color, expected, "default grid line color")


func test_default_grid_line_width() -> void:
	assert_eq(_visualization.grid_line_width, 1.0, "default grid line width")


func test_default_cell_size() -> void:
	assert_eq(_visualization.cell_size, Vector2(64, 32), "default cell size")


func test_set_show_grid_lines() -> void:
	_visualization.show_grid_lines = false
	assert_false(_visualization.show_grid_lines, "show_grid_lines should be false after set")


func test_set_grid_line_color() -> void:
	var new_color := Color(1.0, 0.0, 0.0, 0.8)
	_visualization.grid_line_color = new_color
	assert_eq(_visualization.grid_line_color, new_color, "grid line color should be updated")


func test_set_grid_line_width() -> void:
	_visualization.grid_line_width = 2.5
	assert_eq(_visualization.grid_line_width, 2.5, "grid line width should be updated")


func test_set_map_size() -> void:
	_visualization.set_map_size(10, 8)
	assert_eq(_visualization.map_width, 10, "map width should be 10")
	assert_eq(_visualization.map_height, 8, "map height should be 8")


func test_set_highlighted_coords() -> void:
	var coords: Array = [
		GridCoord.new(0, 0),
		GridCoord.new(1, 1),
		GridCoord.new(2, 2)
	]
	_visualization.set_highlighted_coords(coords)
	assert_eq(_visualization._highlighted_coords.size(), 3, "should have 3 highlighted coords")


func test_add_highlight() -> void:
	_visualization.add_highlight(GridCoord.new(0, 0))
	assert_eq(_visualization._highlighted_coords.size(), 1, "should have 1 highlighted coord")

	_visualization.add_highlight(GridCoord.new(1, 1))
	assert_eq(_visualization._highlighted_coords.size(), 2, "should have 2 highlighted coords")


func test_add_highlight_duplicate() -> void:
	var coord := GridCoord.new(0, 0)
	_visualization.add_highlight(coord)
	_visualization.add_highlight(coord)
	assert_eq(_visualization._highlighted_coords.size(), 1, "duplicate highlight should not be added")


func test_clear_highlights() -> void:
	_visualization.add_highlight(GridCoord.new(0, 0))
	_visualization.add_highlight(GridCoord.new(1, 1))
	assert_eq(_visualization._highlighted_coords.size(), 2, "should have 2 highlights")

	_visualization.clear_highlights()
	assert_eq(_visualization._highlighted_coords.size(), 0, "highlights should be cleared")


func test_highlight_fill_color_default() -> void:
	var expected := Color(0.2, 0.8, 0.2, 0.3)
	assert_eq(_visualization.highlight_fill_color, expected, "default highlight fill color")


func test_highlight_border_color_default() -> void:
	var expected := Color(0.2, 0.8, 0.2, 0.8)
	assert_eq(_visualization.highlight_border_color, expected, "default highlight border color")


func test_set_highlight_colors() -> void:
	var fill := Color(0.5, 0.5, 0.5, 0.5)
	var border := Color(1.0, 1.0, 1.0, 1.0)
	_visualization.highlight_fill_color = fill
	_visualization.highlight_border_color = border

	assert_eq(_visualization.highlight_fill_color, fill, "highlight fill color updated")
	assert_eq(_visualization.highlight_border_color, border, "highlight border color updated")