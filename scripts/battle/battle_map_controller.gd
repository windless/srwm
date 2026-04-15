## BattleMapController
## 战斗地图控制器
## 管理场景初始化、信号连接和战斗流程协调

class_name BattleMapController
extends Node

## BattleCamera 引用
@export var battle_camera: BattleCamera

## GridMapSystem 引用
@export var grid_map_system: GridMapSystem

## UnitPlacement 引用
@export var unit_placement: UnitPlacement

## BattleHUD 引用
@export var battle_hud: BattleHUD

## GridCursor 引用
@export var grid_cursor: GridCursor

## 测试地图数据路径
@export var test_map_data_path: String = ""

## 测试单位数据路径
@export var test_unit_data_path: String = ""

## 测试驾驶员数据路径
@export var test_pilot_data_path: String = ""


func _ready() -> void:
	# 从 NodePath 获取节点引用（如果 @export 没正确解析）
	if battle_camera == null:
		battle_camera = get_node_or_null("BattleCamera")
	if grid_map_system == null:
		grid_map_system = get_node_or_null("GridMapSystem")
	if battle_hud == null:
		battle_hud = get_node_or_null("BattleHUD")
	if grid_cursor == null:
		grid_cursor = get_node_or_null("GridCursor") as GridCursor

	_connect_signals()
	_initialize_scene()


## 连接系统信号
func _connect_signals() -> void:
	# BattleCamera -> GridCursor
	if battle_camera != null and grid_cursor != null:
		battle_camera.cursor_moved.connect(_on_cursor_moved)
		battle_camera.cursor_confirmed.connect(_on_cursor_confirmed)

	# BattleCamera -> UnitPlacement/BattleHUD (旧信号兼容)
	if battle_camera != null:
		battle_camera.grid_cell_selected.connect(_on_grid_cell_selected)

	# UnitPlacement -> BattleHUD
	if unit_placement != null and battle_hud != null:
		unit_placement.unit_placed.connect(_on_unit_placed)
		unit_placement.unit_removed.connect(_on_unit_removed)

	# BattleHUD -> Controller
	if battle_hud != null:
		battle_hud.action_requested.connect(_on_action_requested)

	# 设置 GridMapSystem 引用
	if battle_camera != null and grid_map_system != null:
		battle_camera.grid_map_system = grid_map_system

	if grid_cursor != null and grid_map_system != null:
		grid_cursor.grid_map_system = grid_map_system

	# 设置 UnitPlacement 引用
	if unit_placement != null:
		if grid_map_system != null:
			unit_placement.grid_map_system = grid_map_system
		var units_layer: Node2D = get_node_or_null("UnitsLayer")
		if units_layer != null:
			unit_placement.units_layer = units_layer


## 初始化场景
func _initialize_scene() -> void:
	# 加载测试数据
	_load_test_data()


## 加载测试数据
func _load_test_data() -> void:
	# 创建测试单位数据
	var test_unit_data: UnitData = _create_test_unit_data()
	var test_pilot_data: PilotData = _create_test_pilot_data()
	var enemy_pilot_data: PilotData = _create_enemy_pilot_data()

	# 放置玩家单位
	var player_placement: Array = [
		{
			"unit_data": test_unit_data,
			"pilot_data": test_pilot_data,
			"coord": GridCoord.new(2, 3)
		},
		{
			"unit_data": test_unit_data,
			"pilot_data": test_pilot_data,
			"coord": GridCoord.new(3, 4)
		}
	]

	if unit_placement != null:
		unit_placement.place_player_units(player_placement)

		# 生成敌方单位
		var enemy_config: Dictionary = {
			"count": 3,
			"unit_data": test_unit_data,
			"pilot_data": enemy_pilot_data,
			"exclude_coords": [GridCoord.new(2, 3), GridCoord.new(3, 4)]
		}
		unit_placement.generate_enemy_units(enemy_config)


## 创建测试单位数据
func _create_test_unit_data() -> UnitData:
	var unit: UnitData = UnitData.new()
	unit.name = "Test Unit"
	unit.max_hp = 100
	unit.max_en = 50
	unit.armor = 10
	unit.mobility = 5
	return unit


## 创建测试驾驶员数据（玩家）
func _create_test_pilot_data() -> PilotData:
	var pilot: PilotData = PilotData.new()
	pilot.name = "Test Pilot"
	pilot.level = 5
	pilot.hp_growth = 0.1
	pilot.en_growth = 0.05
	pilot.faction = PilotData.Faction.PLAYER
	return pilot


## 创建敌方驾驶员数据
func _create_enemy_pilot_data() -> PilotData:
	var pilot: PilotData = PilotData.new()
	pilot.name = "Enemy Pilot"
	pilot.level = 3
	pilot.hp_growth = 0.08
	pilot.en_growth = 0.04
	pilot.faction = PilotData.Faction.ENEMY
	return pilot


## 处理网格格子选中事件
func _on_grid_cell_selected(coord: GridCoord) -> void:
	# 查询选中位置的单位
	var unit: UnitInstance = null
	if unit_placement != null:
		unit = unit_placement.get_unit_at(coord)

	# 更新 HUD
	if battle_hud != null:
		battle_hud.on_unit_selection_changed(unit)

	# 打印调试信息
	print("Grid cell selected: %s, Unit: %s" % [coord, unit])


## 处理光标移动事件
func _on_cursor_moved(coord: GridCoord) -> void:
	# 更新光标位置（通过网格坐标计算格子中心）
	if grid_cursor != null:
		grid_cursor.set_coord(coord)
		grid_cursor.set_confirmed_state(false)


## 处理光标确认事件
func _on_cursor_confirmed(coord: GridCoord) -> void:
	# 设置光标确认状态
	if grid_cursor != null:
		grid_cursor.set_confirmed_state(true)

	# 查询选中位置的单位
	var unit: UnitInstance = null
	if unit_placement != null:
		unit = unit_placement.get_unit_at(coord)

	# 更新 HUD
	if battle_hud != null:
		battle_hud.on_unit_selection_changed(unit)

	# 打印调试信息
	print("Cursor confirmed: %s, Unit: %s" % [coord, unit])


## 处理单位放置事件
func _on_unit_placed(unit: UnitInstance, coord: GridCoord) -> void:
	print("Unit placed: %s at %s" % [unit.unit_data.name, coord])


## 处理单位移除事件
func _on_unit_removed(unit: UnitInstance, coord: GridCoord) -> void:
	print("Unit removed: %s from %s" % [unit.unit_data.name, coord])

	# 如果移除的是选中单位，清除 HUD
	if battle_hud != null:
		if unit == battle_hud.get_selected_unit():
			battle_hud.hide_unit_info()
			battle_hud.hide_action_menu()


## 处理行动请求事件
func _on_action_requested(action_type: int, unit: UnitInstance) -> void:
	# 打印调试信息（占位实现）
	var action_name: String = ""
	match action_type:
		ActionMenu.ActionType.MOVE:
			action_name = "MOVE"
		ActionMenu.ActionType.ATTACK:
			action_name = "ATTACK"
		ActionMenu.ActionType.SPIRIT:
			action_name = "SPIRIT"
		ActionMenu.ActionType.WAIT:
			action_name = "WAIT"

	print("Action requested: %s for unit %s" % [action_name, unit.unit_data.name])

	# 占位实现：待机后清除选择
	if action_type == ActionMenu.ActionType.WAIT:
		if battle_hud != null:
			battle_hud.hide_unit_info()
			battle_hud.hide_action_menu()
		if grid_cursor != null:
			grid_cursor.hide_cursor()