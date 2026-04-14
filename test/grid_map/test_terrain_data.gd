## TerrainData 单元测试
## 测试属性加载、切片映射

class_name TestTerrainData
extends GutTest


func test_create_default_plains() -> void:
	var data := TerrainData.create_default(TerrainData.TerrainType.PLAINS)
	assert_eq(data.terrain_type, TerrainData.TerrainType.PLAINS, "terrain type should be plains")
	assert_eq(data.name, "平原", "name should be 平原")
	assert_eq(data.move_cost, 1, "move cost should be 1")
	assert_eq(data.defense_bonus, 0, "defense bonus should be 0")
	assert_true(data.is_passable, "plains should be passable")


func test_create_default_mountain() -> void:
	var data := TerrainData.create_default(TerrainData.TerrainType.MOUNTAIN)
	assert_eq(data.terrain_type, TerrainData.TerrainType.MOUNTAIN, "terrain type should be mountain")
	assert_eq(data.name, "山地", "name should be 山地")
	assert_eq(data.move_cost, 2, "move cost should be 2")
	assert_eq(data.defense_bonus, 10, "defense bonus should be 10")
	assert_true(data.is_passable, "mountain should be passable")


func test_create_default_water() -> void:
	var data := TerrainData.create_default(TerrainData.TerrainType.WATER)
	assert_eq(data.terrain_type, TerrainData.TerrainType.WATER, "terrain type should be water")
	assert_eq(data.name, "水域", "name should be 水域")
	assert_eq(data.move_cost, 99, "move cost should be 99")
	assert_eq(data.defense_bonus, 0, "defense bonus should be 0")
	assert_false(data.is_passable, "water should not be passable")


func test_create_default_structure() -> void:
	var data := TerrainData.create_default(TerrainData.TerrainType.STRUCTURE)
	assert_eq(data.terrain_type, TerrainData.TerrainType.STRUCTURE, "terrain type should be structure")
	assert_eq(data.name, "建筑", "name should be 建筑")
	assert_eq(data.move_cost, 1, "move cost should be 1")
	assert_eq(data.defense_bonus, 15, "defense bonus should be 15")
	assert_true(data.is_passable, "structure should be passable")


func test_get_type_name() -> void:
	var plains := TerrainData.create_default(TerrainData.TerrainType.PLAINS)
	assert_eq(plains.get_type_name(), "平原", "plains type name")

	var mountain := TerrainData.create_default(TerrainData.TerrainType.MOUNTAIN)
	assert_eq(mountain.get_type_name(), "山地", "mountain type name")

	var water := TerrainData.create_default(TerrainData.TerrainType.WATER)
	assert_eq(water.get_type_name(), "水域", "water type name")

	var structure := TerrainData.create_default(TerrainData.TerrainType.STRUCTURE)
	assert_eq(structure.get_type_name(), "建筑", "structure type name")


func test_tile_atlas_coords_default() -> void:
	var data := TerrainData.new()
	assert_eq(data.tile_atlas_coords, Vector2i(0, 0), "default atlas coords should be (0,0)")


func test_load_terrain_resource() -> void:
	var data: TerrainData = load("res://resources/terrain/plain.tres")
	assert_not_null(data, "plain.tres should load")
	assert_eq(data.terrain_type, TerrainData.TerrainType.PLAINS, "loaded plains terrain type")


func test_terrain_data_export_properties() -> void:
	var data := TerrainData.new()
	data.name = "Custom Terrain"
	data.terrain_type = TerrainData.TerrainType.MOUNTAIN
	data.move_cost = 3
	data.defense_bonus = 5
	data.is_passable = true
	data.tile_atlas_coords = Vector2i(2, 1)

	assert_eq(data.name, "Custom Terrain", "custom name")
	assert_eq(data.terrain_type, TerrainData.TerrainType.MOUNTAIN, "custom terrain type")
	assert_eq(data.move_cost, 3, "custom move cost")
	assert_eq(data.defense_bonus, 5, "custom defense bonus")
	assert_true(data.is_passable, "custom passable")
	assert_eq(data.tile_atlas_coords, Vector2i(2, 1), "custom atlas coords")