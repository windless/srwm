class_name TestActionMenu
extends GutTest

## ActionMenu 测试场景路径
const ACTION_MENU_SCENE: String = "res://scenes/ui/action_menu.tscn"

## 测试用的 ActionMenu 实例
var _action_menu: ActionMenu

## 测试用的单位数据
var _test_unit_data: UnitData
var _test_player_pilot: PilotData
var _test_enemy_pilot: PilotData


func before_each() -> void:
	# 创建 ActionMenu 实例
	_action_menu = autofree(load(ACTION_MENU_SCENE).instantiate())
	add_child(_action_menu)

	# 创建测试数据
	_create_test_data()


func _create_test_data() -> void:
	# 创建单位数据
	_test_unit_data = UnitData.new()
	_test_unit_data.name = "Test Unit"
	_test_unit_data.max_hp = 100
	_test_unit_data.max_en = 50

	# 创建玩家驾驶员
	_test_player_pilot = PilotData.new()
	_test_player_pilot.name = "Player Pilot"
	_test_player_pilot.level = 5
	_test_player_pilot.faction = PilotData.Faction.PLAYER

	# 创建敌方驾驶员
	_test_enemy_pilot = PilotData.new()
	_test_enemy_pilot.name = "Enemy Pilot"
	_test_enemy_pilot.level = 3
	_test_enemy_pilot.faction = PilotData.Faction.ENEMY


func _create_player_unit() -> UnitInstance:
	var unit: UnitInstance = UnitInstance.new()
	unit.initialize(_test_unit_data, _test_player_pilot)
	return unit


func _create_enemy_unit() -> UnitInstance:
	var unit: UnitInstance = UnitInstance.new()
	unit.initialize(_test_unit_data, _test_enemy_pilot)
	return unit


func test_initial_state() -> void:
	# 验证初始状态
	assert_false(_action_menu.visible, "ActionMenu should be hidden initially")
	assert_null(_action_menu.get_current_unit(), "Current unit should be null initially")


func test_set_unit_player_shows_full_options() -> void:
	# 设置玩家单位
	var unit: UnitInstance = _create_player_unit()
	_action_menu.set_unit(unit)

	assert_true(_action_menu.visible, "ActionMenu should be visible after set_unit")
	assert_eq(_action_menu.get_option_count(), 4, "Player unit should have 4 options")


func test_set_unit_enemy_shows_limited_options() -> void:
	# 设置敌方单位
	var unit: UnitInstance = _create_enemy_unit()
	_action_menu.set_unit(unit)

	assert_true(_action_menu.visible, "ActionMenu should be visible after set_unit")
	assert_eq(_action_menu.get_option_count(), 2, "Enemy unit should have 2 options")


func test_set_unit_null_hides_menu() -> void:
	# 先设置单位显示
	_action_menu.set_unit(_create_player_unit())
	assert_true(_action_menu.visible)

	# 设置 null 应隐藏
	_action_menu.set_unit(null)
	await wait_seconds(0.2)
	assert_false(_action_menu.visible, "ActionMenu should hide when set_unit(null)")


func test_clear_unit() -> void:
	# 先设置单位
	_action_menu.set_unit(_create_player_unit())
	assert_true(_action_menu.visible)

	# 清除
	_action_menu.clear_unit()
	await wait_seconds(0.2)
	assert_false(_action_menu.visible, "ActionMenu should hide after clear_unit")
	assert_null(_action_menu.get_current_unit())


func test_action_selected_signal() -> void:
	# 设置玩家单位
	_action_menu.set_unit(_create_player_unit())

	# 监听信号
	watch_signals(_action_menu)

	# 模拟选项选中（通过调用内部回调）
	_action_menu._on_option_selected(0)  # Move

	# 验证信号发射
	assert_signal_emitted(_action_menu, "action_selected")


func test_action_selected_after_selection_hides_menu() -> void:
	# 设置玩家单位
	_action_menu.set_unit(_create_player_unit())
	assert_true(_action_menu.visible)

	# 选择行动
	_action_menu._on_option_selected(0)

	# 菜单应隐藏
	await wait_seconds(0.2)
	assert_false(_action_menu.visible, "ActionMenu should hide after action selected")


func test_set_unit_moved_disables_move() -> void:
	# 设置玩家单位
	_action_menu.set_unit(_create_player_unit())

	# 设置已移动状态
	_action_menu.set_unit_moved(true)

	# 验证 Move 选项禁用
	var move_option: Dictionary = _action_menu.get_option(0)
	assert_false(move_option["enabled"], "Move option should be disabled after unit moved")


func test_set_unit_has_targets_disables_attack() -> void:
	# 设置玩家单位
	_action_menu.set_unit(_create_player_unit())

	# 设置无目标状态
	_action_menu.set_unit_has_targets(false)

	# 验证 Attack 选项禁用
	var attack_option: Dictionary = _action_menu.get_option(1)
	assert_false(attack_option["enabled"], "Attack option should be disabled when no targets")