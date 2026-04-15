class_name TestGridCursor
extends GutTest

## GridCursor 测试场景路径
const GRID_CURSOR_SCENE: String = "res://scenes/ui/grid_cursor.tscn"

## 测试用的 GridCursor 实例
var _grid_cursor: GridCursor


func before_each() -> void:
	# 创建 GridCursor 实例
	_grid_cursor = autofree(load(GRID_CURSOR_SCENE).instantiate())
	add_child(_grid_cursor)


func test_initial_state() -> void:
	# 验证初始状态
	assert_false(_grid_cursor.visible, "GridCursor should be hidden initially")
	assert_null(_grid_cursor.get_current_coord(), "Current coord should be null initially")


func test_set_coord_shows_cursor() -> void:
	# 设置有效坐标后光标应显示
	var coord: GridCoord = GridCoord.new(5, 5)
	_grid_cursor.set_coord(coord)

	assert_true(_grid_cursor.visible, "GridCursor should be visible after set_coord")
	assert_not_null(_grid_cursor.get_current_coord(), "Current coord should not be null")


func test_set_coord_null_hides_cursor() -> void:
	# 先设置坐标显示
	_grid_cursor.set_coord(GridCoord.new(5, 5))
	assert_true(_grid_cursor.visible)

	# 设置 null 应隐藏
	_grid_cursor.set_coord(null)
	assert_false(_grid_cursor.visible, "GridCursor should hide when set_coord(null)")
	assert_null(_grid_cursor.get_current_coord())


func test_hide_cursor() -> void:
	# 先设置坐标显示
	_grid_cursor.set_coord(GridCoord.new(5, 5))
	assert_true(_grid_cursor.visible)

	# 调用 hide_cursor
	_grid_cursor.hide_cursor()
	assert_false(_grid_cursor.visible, "GridCursor should hide after hide_cursor()")
	assert_null(_grid_cursor.get_current_coord())


func test_set_confirmed_state() -> void:
	# 设置坐标
	_grid_cursor.set_coord(GridCoord.new(5, 5))

	# 设置确认状态
	_grid_cursor.set_confirmed_state(true)

	# 验证确认状态（通过边框颜色变化）
	# 无法直接访问内部颜色，但可以验证方法不崩溃
	assert_true(_grid_cursor.visible, "GridCursor should still be visible after confirmed state")

	# 重置确认状态
	_grid_cursor.set_confirmed_state(false)
	assert_true(_grid_cursor.visible, "GridCursor should still be visible")


func test_border_lines_created() -> void:
	# 验证边框线条数量
	var line_count: int = 0
	for child in _grid_cursor.get_children():
		if child is Line2D:
			line_count += 1

	assert_eq(line_count, 4, "GridCursor should have 4 Line2D children for border")