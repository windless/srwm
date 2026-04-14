## GridMapSystem 单元测试
## 测试地图生成、地形查询、TileMapLayer 同步

class_name TestGridMapSystem
extends GutTest


var _grid_system: GridMapSystem


func before_each() -> void:
	_grid_system = GridMapSystem.new()
	_grid_system.width = 5
	_grid_system.height = 5
	_grid_system._ready()


func after_each() -> void:
	if _grid_system != null:
		_grid_system.cleanup()
		_grid_system.free()
		_grid_system = null


func test_initialize_map_default_size() -> void:
	assert_eq(_grid_system.width, 5, "width should be 5")
	assert_eq(_grid_system.height, 5, "height should be 5")


func test_initialize_map_all_plains() -> void:
	for y in range(_grid_system.height):
		for x in range(_grid_system.width):
			var terrain := _grid_system.get_terrain_at(GridCoord.new(x, y))
			assert_not_null(terrain, "terrain at (%d,%d) should not be null" % [x, y])
			assert_eq(
				terrain.terrain_type,
				TerrainData.TerrainType.PLAINS,
				"terrain type should be plains"
			)


func test_create_empty_map() -> void:
	_grid_system.create_empty_map(10, 8)
	assert_eq(_grid_system.width, 10, "new width should be 10")
	assert_eq(_grid_system.height, 8, "new height should be 8")


func test_get_bounds() -> void:
	var bounds := _grid_system.get_bounds()
	assert_eq(bounds.x, 5, "bounds width")
	assert_eq(bounds.y, 5, "bounds height")


func test_get_min_coord() -> void:
	var min := _grid_system.get_min_coord()
	assert_eq(min.x, 0, "min x should be 0")
	assert_eq(min.y, 0, "min y should be 0")


func test_get_max_coord() -> void:
	var max := _grid_system.get_max_coord()
	assert_eq(max.x, 4, "max x should be 4")
	assert_eq(max.y, 4, "max y should be 4")


func test_is_valid_coord_positive() -> void:
	var coord := GridCoord.new(2, 3)
	assert_true(_grid_system.is_valid_coord(coord), "coord inside bounds should be valid")


func test_is_valid_coord_out_of_bounds() -> void:
	var coord := GridCoord.new(10, 3)
	assert_false(_grid_system.is_valid_coord(coord), "coord outside bounds should be invalid")


func test_is_valid_coord_negative() -> void:
	var coord := GridCoord.new(-1, 2)
	assert_false(_grid_system.is_valid_coord(coord), "negative coord should be invalid")


func test_set_terrain_at() -> void:
	var coord := GridCoord.new(2, 2)
	_grid_system.set_terrain_at(coord, TerrainData.TerrainType.MOUNTAIN)

	var terrain := _grid_system.get_terrain_at(coord)
	assert_eq(
		terrain.terrain_type,
		TerrainData.TerrainType.MOUNTAIN,
		"terrain should be mountain after set"
	)


func test_get_terrain_type_at() -> void:
	var coord := GridCoord.new(1, 1)
	_grid_system.set_terrain_at(coord, TerrainData.TerrainType.WATER)

	var type := _grid_system.get_terrain_type_at(coord)
	assert_eq(type, TerrainData.TerrainType.WATER, "terrain type should be water")


func test_get_terrain_at_invalid_coord() -> void:
	var coord := GridCoord.new(100, 100)
	var terrain := _grid_system.get_terrain_at(coord)
	assert_null(terrain, "invalid coord should return null")


func test_get_terrain_type_at_invalid_coord() -> void:
	var coord := GridCoord.new(-1, -1)
	var type := _grid_system.get_terrain_type_at(coord)
	assert_eq(type, -1, "invalid coord should return -1")


func test_is_passable_at_plains() -> void:
	var coord := GridCoord.new(0, 0)
	assert_true(_grid_system.is_passable_at(coord), "plains should be passable")


func test_is_passable_at_water() -> void:
	var coord := GridCoord.new(1, 1)
	_grid_system.set_terrain_at(coord, TerrainData.TerrainType.WATER)
	assert_false(_grid_system.is_passable_at(coord), "water should not be passable")


func test_is_passable_at_invalid_coord() -> void:
	var coord := GridCoord.new(-1, -1)
	assert_false(_grid_system.is_passable_at(coord), "invalid coord should return false")


func test_get_screen_from_coord() -> void:
	var coord := GridCoord.new(0, 0)
	var screen := _grid_system.get_screen_from_coord(coord)
	# Without TileMap, uses default 64x32 cell size
	assert_eq(screen.x, 0.0, "origin screen x")
	assert_eq(screen.y, 0.0, "origin screen y")


func test_get_coord_from_screen() -> void:
	var screen := Vector2(0, 0)
	var coord := _grid_system.get_coord_from_screen(screen)
	assert_eq(coord.x, 0, "from screen origin x")
	assert_eq(coord.y, 0, "from screen origin y")


func test_load_map_data() -> void:
	var map_data := MapData.create_test_map()
	_grid_system.load_map_data(map_data)

	assert_eq(_grid_system.width, 10, "loaded width")
	assert_eq(_grid_system.height, 10, "loaded height")

	# Check mountain at position (2, 2)
	var terrain := _grid_system.get_terrain_at(GridCoord.new(2, 2))
	assert_eq(
		terrain.terrain_type,
		TerrainData.TerrainType.MOUNTAIN,
		"loaded mountain terrain"
	)


func test_get_all_coords() -> void:
	var coords := _grid_system.get_all_coords()
	assert_eq(coords.size(), 25, "5x5 map should have 25 coords")


func test_terrain_cache_loaded() -> void:
	assert_not_null(
		_grid_system._terrain_cache[TerrainData.TerrainType.PLAINS],
		"plains cache should be loaded"
	)
	assert_not_null(
		_grid_system._terrain_cache[TerrainData.TerrainType.MOUNTAIN],
		"mountain cache should be loaded"
	)
	assert_not_null(
		_grid_system._terrain_cache[TerrainData.TerrainType.WATER],
		"water cache should be loaded"
	)
	assert_not_null(
		_grid_system._terrain_cache[TerrainData.TerrainType.STRUCTURE],
		"structure cache should be loaded"
	)