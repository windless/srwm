## MapData
## 地图数据 Resource，用于存储预定义地图配置

class_name MapData
extends Resource

## 地图名称
@export var map_name: String = "Default Map"

## 地图宽度
@export var width: int = 10

## 地图高度
@export var height: int = 10

## 地形数据数组（每行数据用 Array 存储）
## 格式: [[row0_type0, row0_type1, ...], [row1_type0, row1_type1, ...], ...]
## 值为 TerrainType 枚举值
@export var terrain_grid: Array = []


## 验证数据有效性
func is_valid() -> bool:
	return width > 0 and height > 0 and terrain_grid.size() == height


## 获取指定坐标的地形类型
func get_terrain_type_at(x: int, y: int) -> int:
	if y < 0 or y >= terrain_grid.size():
		return TerrainData.TerrainType.PLAINS
	var row: Array = terrain_grid[y]
	if x < 0 or x >= row.size():
		return TerrainData.TerrainType.PLAINS
	return row[x]


## 创建空地图数据
static func create_empty(
	map_width: int,
	map_height: int,
	fill_type: int = TerrainData.TerrainType.PLAINS
) -> MapData:
	var data := MapData.new()
	data.width = map_width
	data.height = map_height
	data.terrain_grid.clear()

	for y in range(map_height):
		var row: Array = []
		for x in range(map_width):
			row.append(fill_type)
		data.terrain_grid.append(row)

	return data


## 创建示例测试地图
static func create_test_map() -> MapData:
	var data := MapData.new()
	data.map_name = "Test Map"
	data.width = 10
	data.height = 10

	# 创建地形网格（包含多种地形类型）
	data.terrain_grid = [
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  # row 0: 平原
		[0, 0, 1, 1, 0, 0, 0, 2, 0, 0],  # row 1: 山地和水域
		[0, 1, 1, 1, 1, 0, 2, 2, 0, 0],  # row 2: 山地和水域
		[0, 0, 1, 1, 0, 0, 0, 2, 0, 0],  # row 3: 山地和水域
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  # row 4: 平原
		[0, 0, 0, 0, 3, 3, 0, 0, 0, 0],  # row 5: 建筑
		[0, 0, 0, 3, 3, 3, 3, 0, 0, 0],  # row 6: 建筑
		[0, 0, 0, 0, 3, 3, 0, 0, 0, 0],  # row 7: 建筑
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  # row 8: 平原
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  # row 9: 平原
	]

	return data