## GridCoord 单元测试
## 测试坐标运算、有效性检查、斜视角转换

class_name TestGridCoord
extends GutTest

const CELL_SIZE := Vector2(64, 32)


func test_init_with_xy() -> void:
	var coord := GridCoord.new(5, 10)
	assert_eq(coord.x, 5, "x coordinate should be 5")
	assert_eq(coord.y, 10, "y coordinate should be 10")


func test_init_with_default() -> void:
	var coord := GridCoord.new()
	assert_eq(coord.x, 0, "default x should be 0")
	assert_eq(coord.y, 0, "default y should be 0")


func test_from_vector2i() -> void:
	var vec := Vector2i(3, 7)
	var coord := GridCoord.from_vector2i(vec)
	assert_eq(coord.x, 3, "x from Vector2i")
	assert_eq(coord.y, 7, "y from Vector2i")


func test_to_vector2i() -> void:
	var coord := GridCoord.new(4, 8)
	var vec := coord.to_vector2i()
	assert_eq(vec.x, 4, "Vector2i x")
	assert_eq(vec.y, 8, "Vector2i y")


func test_is_valid_in_bounds() -> void:
	var coord := GridCoord.new(5, 5)
	var bounds := Vector2i(10, 10)
	assert_true(coord.is_valid_in_bounds(bounds), "coord should be valid in bounds")


func test_is_valid_out_of_bounds() -> void:
	var coord := GridCoord.new(15, 5)
	var bounds := Vector2i(10, 10)
	assert_false(coord.is_valid_in_bounds(bounds), "coord should be invalid out of bounds")


func test_is_valid_negative() -> void:
	var coord := GridCoord.new(-1, 5)
	var bounds := Vector2i(10, 10)
	assert_false(coord.is_valid_in_bounds(bounds), "negative coord should be invalid")


func test_is_negative() -> void:
	var coord1 := GridCoord.new(-1, 5)
	assert_true(coord1.is_negative(), "negative x should return true")

	var coord2 := GridCoord.new(5, -1)
	assert_true(coord2.is_negative(), "negative y should return true")

	var coord3 := GridCoord.new(5, 5)
	assert_false(coord3.is_negative(), "positive coords should return false")


func test_add() -> void:
	var coord1 := GridCoord.new(3, 4)
	var coord2 := GridCoord.new(2, 5)
	var result := coord1.add(coord2)
	assert_eq(result.x, 5, "add x")
	assert_eq(result.y, 9, "add y")


func test_manhattan_distance() -> void:
	var coord1 := GridCoord.new(0, 0)
	var coord2 := GridCoord.new(3, 4)
	var distance := coord1.manhattan_distance(coord2)
	assert_eq(distance, 7, "manhattan distance should be 7")


func test_manhattan_distance_same() -> void:
	var coord := GridCoord.new(5, 5)
	var distance := coord.manhattan_distance(coord)
	assert_eq(distance, 0, "distance to self should be 0")


func test_is_adjacent() -> void:
	var center := GridCoord.new(5, 5)

	var up := GridCoord.new(5, 4)
	assert_true(center.is_adjacent(up), "up should be adjacent")

	var down := GridCoord.new(5, 6)
	assert_true(center.is_adjacent(down), "down should be adjacent")

	var left := GridCoord.new(4, 5)
	assert_true(center.is_adjacent(left), "left should be adjacent")

	var right := GridCoord.new(6, 5)
	assert_true(center.is_adjacent(right), "right should be adjacent")

	var far := GridCoord.new(7, 7)
	assert_false(center.is_adjacent(far), "far coord should not be adjacent")


func test_to_screen_origin() -> void:
	var coord := GridCoord.new(0, 0)
	var screen := coord.to_screen(CELL_SIZE)
	assert_eq(screen.x, 0.0, "origin screen x should be 0")
	assert_eq(screen.y, 0.0, "origin screen y should be 0")


func test_to_screen_positive() -> void:
	var coord := GridCoord.new(2, 1)
	var screen := coord.to_screen(CELL_SIZE)
	# (2 - 1) * 32 = 32
	# (2 + 1) * 16 = 48
	assert_eq(screen.x, 32.0, "screen x for (2,1)")
	assert_eq(screen.y, 48.0, "screen y for (2,1)")


func test_from_screen_origin() -> void:
	var screen := Vector2(0, 0)
	var coord := GridCoord.from_screen(screen, CELL_SIZE)
	assert_eq(coord.x, 0, "from screen origin x")
	assert_eq(coord.y, 0, "from screen origin y")


func test_from_screen_roundtrip() -> void:
	var original := GridCoord.new(3, 5)
	var screen := original.to_screen(CELL_SIZE)
	var result := GridCoord.from_screen(screen, CELL_SIZE)
	assert_eq(result.x, original.x, "roundtrip x")
	assert_eq(result.y, original.y, "roundtrip y")


func test_equals() -> void:
	var coord1 := GridCoord.new(3, 5)
	var coord2 := GridCoord.new(3, 5)
	assert_true(coord1.equals(coord2), "same coords should be equal")

	var coord3 := GridCoord.new(3, 6)
	assert_false(coord1.equals(coord3), "different coords should not be equal")


func test_to_string() -> void:
	var coord := GridCoord.new(3, 5)
	var str := coord._to_string()
	assert_eq(str, "GridCoord(3, 5)", "string representation")