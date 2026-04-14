## TerrainData
## 地形属性模板 Resource，定义每种地形的属性

class_name TerrainData
extends Resource

## 地形类型枚举
enum TerrainType {
	PLAINS,      ## 平原 - 默认地形，移动消耗低
	MOUNTAIN,    ## 山地 - 移动消耗高，提供防御加成
	WATER,       ## 水域 - 不可通过地形
	STRUCTURE,   ## 建筑 - 提供最高防御加成
}

## 地形名称
@export var name: String = "Unknown"

## 地形类型
@export var terrain_type: int = TerrainType.PLAINS

## 移动消耗（默认1）
@export_range(1, 99) var move_cost: int = 1

## 防御修正（默认0）
@export_range(0, 30) var defense_bonus: int = 0

## 是否可通过（默认true）
@export var is_passable: bool = true

## TileMap 切片坐标（用于视觉渲染）
@export var tile_atlas_coords: Vector2i = Vector2i(0, 0)


## 获取地形类型名称
func get_type_name() -> String:
	match terrain_type:
		TerrainType.PLAINS:
			return "平原"
		TerrainType.MOUNTAIN:
			return "山地"
		TerrainType.WATER:
			return "水域"
		TerrainType.STRUCTURE:
			return "建筑"
		_:
			return "未知"


## 创建默认地形数据
static func create_default(type: int) -> TerrainData:
	var data := TerrainData.new()
	data.terrain_type = type
	match type:
		TerrainType.PLAINS:
			data.name = "平原"
			data.move_cost = 1
			data.defense_bonus = 0
			data.is_passable = true
		TerrainType.MOUNTAIN:
			data.name = "山地"
			data.move_cost = 2
			data.defense_bonus = 10
			data.is_passable = true
		TerrainType.WATER:
			data.name = "水域"
			data.move_cost = 99
			data.defense_bonus = 0
			data.is_passable = false
		TerrainType.STRUCTURE:
			data.name = "建筑"
			data.move_cost = 1
			data.defense_bonus = 15
			data.is_passable = true
	return data