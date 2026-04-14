## UnitPlacement
## 单位放置系统，管理单位在地图上的初始部署和查询
## 支持玩家单位预设位置和敌方单位动态生成

class_name UnitPlacement
extends Node

## 信号：单位被放置
signal unit_placed(unit: UnitInstance, coord: GridCoord)

## 信号：单位被移除
signal unit_removed(unit: UnitInstance, coord: GridCoord)

## GridMapSystem 引用（用于坐标验证）
@export var grid_map_system: GridMapSystem

## UnitsLayer 引用（单位渲染容器）
@export var units_layer: Node2D

## UnitRenderer 场景路径
@export var unit_renderer_scene: PackedScene

## 网格单元格尺寸（用于坐标转换）
@export var cell_size: Vector2 = Vector2(64, 32)

## 单位注册表：GridCoord -> UnitInstance
## 使用 Dictionary 存储单位与位置的映射
var _unit_registry: Dictionary = {}

## 单位渲染器注册表：UnitInstance -> UnitRenderer 节点
var _renderer_registry: Dictionary = {}

## 所有单位列表
var _all_units: Array[UnitInstance] = []


func _ready() -> void:
	# 如果没有预设 UnitRenderer 场景，尝试加载默认场景
	if unit_renderer_scene == null:
		unit_renderer_scene = load("res://scenes/units/unit_renderer.tscn")


## 放置玩家单位（从预设配置加载）
## placement_data: Array of Dictionary
## { "unit_data": UnitData, "pilot_data": PilotData, "coord": GridCoord }
func place_player_units(placement_data: Array) -> void:
	for entry in placement_data:
		var unit_data: UnitData = entry.get("unit_data")
		var pilot_data: PilotData = entry.get("pilot_data")
		var coord: GridCoord = entry.get("coord")

		if unit_data == null or pilot_data == null or coord == null:
			push_warning("Invalid placement entry: missing data")
			continue

		# 验证坐标有效性
		if not _is_valid_placement_coord(coord):
			push_warning("Invalid placement coord: %s" % coord)
			continue

		# 检查位置是否已被占用
		if _unit_registry.has(coord.to_string()):
			push_warning("Duplicate placement at %s, skipping" % coord)
			continue

		# 创建单位实例
		_create_unit_at(unit_data, pilot_data, coord)


## 动态生成敌方单位
## enemy_config: Dictionary
## { "count": int, "unit_data": UnitData, "pilot_data": PilotData, "exclude_coords": Array }
func generate_enemy_units(enemy_config: Dictionary) -> void:
	var count: int = enemy_config.get("count", 0)
	var unit_data: UnitData = enemy_config.get("unit_data")
	var pilot_data: PilotData = enemy_config.get("pilot_data")
	var exclude_coords: Array = enemy_config.get("exclude_coords", [])

	if count <= 0 or unit_data == null or pilot_data == null:
		push_warning("Invalid enemy configuration")
		return

	# 获取可用位置
	var available_coords: Array = _get_available_coords_for_enemies(count, exclude_coords)

	# 生成敌方单位
	for i in range(mini(count, available_coords.size())):
		var coord: GridCoord = available_coords[i]
		_create_unit_at(unit_data, pilot_data, coord)


## 创建单位并放置在指定位置
func _create_unit_at(unit_data: UnitData, pilot_data: PilotData, coord: GridCoord) -> void:
	# 创建 UnitInstance
	var unit_instance: UnitInstance = UnitInstance.new()
	unit_instance.initialize(unit_data, pilot_data)

	# 创建 UnitRenderer
	var renderer: Node2D = _create_renderer(unit_instance, coord)

	# 注册单位
	_unit_registry[coord.to_string()] = unit_instance
	_renderer_registry[unit_instance] = renderer
	_all_units.append(unit_instance)

	# 发出信号
	emit_signal("unit_placed", unit_instance, coord)

	# 更新渲染顺序
	_update_render_order()


## 创建单位渲染器
func _create_renderer(unit: UnitInstance, coord: GridCoord) -> Node2D:
	var renderer: Node2D

	if unit_renderer_scene != null:
		renderer = unit_renderer_scene.instantiate()
	else:
		renderer = Node2D.new()

	# 设置渲染器位置
	var screen_pos: Vector2 = coord.to_screen(cell_size)
	renderer.position = screen_pos

	# 设置渲染器名称（便于调试）
	renderer.name = "Unit_%s" % unit.unit_data.name

	# 配置 UnitRenderer 属性（如果场景是 UnitRenderer）
	if renderer is UnitRenderer:
		# 加载精灵表纹理
		var sprite_sheet: Texture2D = load(
			"res://assets/sprites/ID00001_decrypted.png"
		)
		renderer.sprite_sheet = sprite_sheet

		# 根据阵营设置不同的机甲索引
		# 玩家单位使用索引 0-3，敌方使用索引 4-7
		if unit.is_enemy():
			renderer.unit_index = 4 + randi() % 4
		else:
			renderer.unit_index = randi() % 4

		# 设置初始朝向（面向对手）
		if unit.is_enemy():
			renderer.direction = UnitRenderer.Direction.NORTH
		else:
			renderer.direction = UnitRenderer.Direction.SOUTH

	# 添加到 UnitsLayer
	if units_layer != null:
		units_layer.add_child(renderer)

	return renderer


## 验证放置坐标是否有效
func _is_valid_placement_coord(coord: GridCoord) -> bool:
	if grid_map_system == null:
		return true  # 无 GridMapSystem 时默认接受

	return grid_map_system.is_valid_coord(coord)


## 获取敌方单位可用位置
func _get_available_coords_for_enemies(count: int, exclude_coords: Array) -> Array:
	var available: Array = []

	if grid_map_system == null:
		return available

	var bounds: Vector2i = grid_map_system.get_bounds()

	# 收集已占用位置
	var occupied: Dictionary = {}
	for coord_str in _unit_registry.keys():
		occupied[coord_str] = true
	for coord in exclude_coords:
		occupied[coord.to_string()] = true

	# 收集可用位置（从地图边缘开始）
	# 优先选择远离玩家的位置（地图底部和右侧）
	for y in range(bounds.y - 1, int(bounds.y / 2.0), -1):
		for x in range(bounds.x - 1, int(bounds.x / 2.0), -1):
			var coord: GridCoord = GridCoord.new(x, y)
			if not occupied.has(coord.to_string()):
				available.append(coord)
				if available.size() >= count:
					return available

	# 如果边缘位置不足，从剩余区域收集
	for y in range(bounds.y):
		for x in range(bounds.x):
			var coord: GridCoord = GridCoord.new(x, y)
			if not occupied.has(coord.to_string()):
				available.append(coord)
				if available.size() >= count:
					return available

	return available


## 获取指定位置的单位
func get_unit_at(coord: GridCoord) -> UnitInstance:
	var coord_str: String = coord.to_string()
	return _unit_registry.get(coord_str)


## 获取所有单位
func get_all_units() -> Array[UnitInstance]:
	return _all_units.duplicate()


## 获取指定阵营的单位
func get_units_by_faction(faction: int) -> Array[UnitInstance]:
	var result: Array[UnitInstance] = []
	for unit in _all_units:
		if unit.pilot_data.faction == faction:
			result.append(unit)
	return result


## 获取玩家单位
func get_player_units() -> Array[UnitInstance]:
	return get_units_by_faction(PilotData.Faction.PLAYER)


## 获取敌方单位
func get_enemy_units() -> Array[UnitInstance]:
	return get_units_by_faction(PilotData.Faction.ENEMY)


## 更新单位渲染顺序（Y-sorting）
func _update_render_order() -> void:
	if units_layer == null:
		return

	# 获取所有渲染器并按 Y 坐标排序
	var renderers: Array = []
	for unit in _renderer_registry.keys():
		var renderer: Node2D = _renderer_registry[unit]
		var coord: GridCoord = _get_coord_for_unit(unit)
		if coord != null:
			renderers.append({ "renderer": renderer, "y": coord.y, "x": coord.x })

	# 排序：Y 坐标升序，同 Y 时 X 坐标升序
	renderers.sort_custom(_compare_render_order)

	# 更新节点顺序
	for i in range(renderers.size()):
		var renderer: Node2D = renderers[i]["renderer"]
		units_layer.move_child(renderer, i)


## 渲染顺序比较函数
func _compare_render_order(a: Dictionary, b: Dictionary) -> bool:
	if a["y"] != b["y"]:
		return a["y"] < b["y"]
	return a["x"] < b["x"]


## 获取单位对应的坐标
func _get_coord_for_unit(unit: UnitInstance) -> GridCoord:
	for coord_str in _unit_registry.keys():
		if _unit_registry[coord_str] == unit:
			# 解析坐标字符串
			var parts: Array = coord_str.split(",")
			if parts.size() == 2:
				return GridCoord.new(int(parts[0].replace("GridCoord(", "")), int(parts[1].replace(")", "")))
	return null


## 移除单位
func remove_unit(unit: UnitInstance) -> void:
	if unit == null:
		return

	# 获取单位坐标
	var coord: GridCoord = _get_coord_for_unit(unit)
	if coord == null:
		return

	# 移除渲染器
	var renderer: Node2D = _renderer_registry.get(unit)
	if renderer != null and units_layer != null:
		renderer.queue_free()

	# 清除注册
	_unit_registry.erase(coord.to_string())
	_renderer_registry.erase(unit)
	_all_units.erase(unit)

	# 发出信号
	emit_signal("unit_removed", unit, coord)


## 清除所有单位
func clear_all_units() -> void:
	# 移除所有渲染器
	for renderer in _renderer_registry.values():
		if renderer != null and units_layer != null:
			renderer.queue_free()

	# 清除注册表
	_unit_registry.clear()
	_renderer_registry.clear()
	_all_units.clear()


## 获取单位数量
func get_unit_count() -> int:
	return _all_units.size()


## 获取单位渲染器
func get_renderer_for_unit(unit: UnitInstance) -> Node2D:
	return _renderer_registry.get(unit)
