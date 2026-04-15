## GridMapSystem
## 网格地图管理节点，管理地图网格状态和查询
## 配合 TileMapLayer 进行视觉渲染

class_name GridMapSystem
extends Node

## 地图宽度（网格数量）
@export var width: int = 10

## 地图高度（网格数量）
@export var height: int = 10

## TileMapLayer 节点引用（用于视觉渲染）
@export var tile_layer: TileMapLayer

## 默认地形类型（空地图填充）
@export var default_terrain_type: int = TerrainData.TerrainType.PLAINS

## 地图数据（二维数组存储 TerrainData 引用）
var _terrain_data: Array[Array] = []

## 地形数据缓存（按类型索引）
var _terrain_cache: Dictionary = {}

## 地图边界
var _bounds: Vector2i = Vector2i.ZERO


## 节点进入场景树时初始化
func _ready() -> void:
	_initialize_terrain_cache()
	_initialize_map()


## 初始化地形数据缓存
func _initialize_terrain_cache() -> void:
	_terrain_cache.clear()
	# 加载默认地形数据
	_terrain_cache[TerrainData.TerrainType.PLAINS] = load(
		"res://resources/terrain/plain.tres"
	)
	_terrain_cache[TerrainData.TerrainType.MOUNTAIN] = load(
		"res://resources/terrain/mountain.tres"
	)
	_terrain_cache[TerrainData.TerrainType.WATER] = load(
		"res://resources/terrain/water.tres"
	)
	_terrain_cache[TerrainData.TerrainType.STRUCTURE] = load(
		"res://resources/terrain/structure.tres"
	)


## 初始化地图数据结构
func _initialize_map() -> void:
	_bounds = Vector2i(width, height)
	_terrain_data.clear()

	# 创建二维数组并填充默认地形
	for y in range(height):
		var row: Array = []
		for x in range(width):
			row.append(_terrain_cache.get(
				default_terrain_type,
				_terrain_cache[TerrainData.TerrainType.PLAINS]
			))
		_terrain_data.append(row)

	# 同步 TileMapLayer
	_sync_tile_layer()


## 同步 TileMapLayer 切片显示
func _sync_tile_layer() -> void:
	if tile_layer == null:
		return

	# 清除所有切片
	tile_layer.clear()

	for y in range(height):
		for x in range(width):
			var terrain: TerrainData = _terrain_data[y][x]
			if terrain != null:
				tile_layer.set_cell(
					Vector2i(x, y),
					0,
					terrain.tile_atlas_coords
				)


## 创建空地图（指定尺寸，填充默认地形）
func create_empty_map(map_width: int, map_height: int) -> void:
	width = map_width
	height = map_height
	_initialize_map()


## 获取指定坐标的地形数据
func get_terrain_at(coord: GridCoord) -> TerrainData:
	if not is_valid_coord(coord):
		return null
	return _terrain_data[coord.y][coord.x]


## 获取指定坐标的地形类型
func get_terrain_type_at(coord: GridCoord) -> int:
	var terrain: TerrainData = get_terrain_at(coord)
	if terrain == null:
		return -1
	return terrain.terrain_type


## 设置指定坐标的地形类型
func set_terrain_at(coord: GridCoord, terrain_type: int) -> void:
	if not is_valid_coord(coord):
		return

	var terrain: TerrainData = _terrain_cache.get(terrain_type)
	if terrain == null:
		return

	_terrain_data[coord.y][coord.x] = terrain

	# 同步 TileMapLayer
	if tile_layer != null:
		tile_layer.set_cell(
			Vector2i(coord.x, coord.y),
			0,
			terrain.tile_atlas_coords
		)


## 检查坐标是否在地图范围内
func is_valid_coord(coord: GridCoord) -> bool:
	return coord.x >= 0 and coord.y >= 0 and coord.x < width and coord.y < height


## 检查指定坐标是否可通过
func is_passable_at(coord: GridCoord) -> bool:
	var terrain: TerrainData = get_terrain_at(coord)
	if terrain == null:
		return false
	return terrain.is_passable


## 获取地图边界
func get_bounds() -> Vector2i:
	return _bounds


## 获取最小坐标
func get_min_coord() -> GridCoord:
	return GridCoord.new(0, 0)


## 获取最大坐标
func get_max_coord() -> GridCoord:
	return GridCoord.new(width - 1, height - 1)


## 从屏幕坐标获取网格坐标
func get_coord_from_screen(screen_pos: Vector2) -> GridCoord:
	if tile_layer == null:
		return GridCoord.from_screen(screen_pos, Vector2(64, 32))
	# TileMapLayer 提供坐标转换
	return GridCoord.from_vector2i(
		tile_layer.local_to_map(tile_layer.to_local(screen_pos))
	)


## 从网格坐标获取屏幕坐标
func get_screen_from_coord(coord: GridCoord) -> Vector2:
	if tile_layer == null:
		# 使用 TileMap 的 tile_size（从 tile_set 获取）
		var cell_size_v2: Vector2 = Vector2(64, 32)
		if tile_layer != null and tile_layer.tile_set != null:
			var ts_size: Vector2i = tile_layer.tile_set.tile_size
			# 等距投影需要 2x
			cell_size_v2 = Vector2(ts_size.x, ts_size.y) * 2
		return coord.to_screen(cell_size_v2)
	return tile_layer.to_global(
		tile_layer.map_to_local(Vector2i(coord.x, coord.y))
	)


## 从 MapData Resource 加载地图
func load_map_data(map_data: MapData) -> void:
	if map_data == null or not map_data.is_valid():
		return

	width = map_data.width
	height = map_data.height
	_bounds = Vector2i(width, height)

	# 重新初始化地图数据结构
	_terrain_data.clear()
	for y in range(height):
		var row: Array = []
		for x in range(width):
			var terrain_type: int = map_data.get_terrain_type_at(x, y)
			row.append(_terrain_cache.get(
				terrain_type,
				_terrain_cache[TerrainData.TerrainType.PLAINS]
			))
		_terrain_data.append(row)

	# 同步 TileMapLayer
	_sync_tile_layer()


## 加载地图数据文件（从 Resource 路径）
func load_map_from_path(path: String) -> void:
	var map_data: MapData = load(path) as MapData
	if map_data != null:
		load_map_data(map_data)


## 获取所有网格坐标列表
func get_all_coords() -> Array:
	var coords: Array = []
	for y in range(height):
		for x in range(width):
			coords.append(GridCoord.new(x, y))
	return coords


## 清理资源（用于测试或场景卸载）
func cleanup() -> void:
	_terrain_cache.clear()
	_terrain_data.clear()
	_bounds = Vector2i.ZERO