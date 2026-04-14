## test_example_data_integration.gd
## 验证示例数据加载正确 - 集成测试

class_name TestExampleDataIntegration
extends GutTest

# 预加载类定义脚本（GUT 在 Godot 4 中需要）
var WeaponDataScript := preload("res://scripts/weapons/weapon_data.gd")
var PilotDataScript := preload("res://scripts/pilots/pilot_data.gd")
var UnitDataScript := preload("res://scripts/units/unit_data.gd")
var UnitInstanceScript := preload("res://scripts/units/unit_instance.gd")

# 预加载资源（避免 duplicated-load lint 错误）
var _player_unit := preload("res://resources/units/example_player.tres")
var _enemy_unit := preload("res://resources/units/example_enemy.tres")
var _player_pilot := preload("res://resources/pilots/example_player_pilot.tres")
var _enemy_pilot := preload("res://resources/pilots/example_enemy_pilot.tres")


func test_all_example_resources_loadable() -> void:
	# 加载所有示例资源并验证
	var units := [
		"res://resources/units/example_player.tres",
		"res://resources/units/example_enemy.tres"
	]
	var pilots := [
		"res://resources/pilots/example_player_pilot.tres",
		"res://resources/pilots/example_enemy_pilot.tres"
	]
	var weapons := [
		"res://resources/weapons/beam_saber.tres",
		"res://resources/weapons/rifle.tres"
	]

	for unit_path in units:
		var unit = load(unit_path)
		assert_not_null(unit, "单位资源 %s 应加载成功" % unit_path)
		assert_gt(unit.max_hp, 0, "单位 %s 应有有效 HP" % unit_path)

	for pilot_path in pilots:
		var pilot = load(pilot_path)
		assert_not_null(pilot, "驾驶员资源 %s 应加载成功" % pilot_path)
		assert_gt(pilot.level, 0, "驾驶员 %s 应有有效等级" % pilot_path)

	for weapon_path in weapons:
		var weapon = load(weapon_path)
		assert_not_null(weapon, "武器资源 %s 应加载成功" % weapon_path)
		assert_gt(weapon.power, 0, "武器 %s 应有有效攻击力" % weapon_path)


func test_player_unit_has_correct_weapons() -> void:
	assert_eq(_player_unit.weapons.size(), 2, "玩家单位应有 2 个武器")

	# 验证武器引用有效
	var saber = _player_unit.weapons[0]
	var rifle = _player_unit.weapons[1]

	assert_eq(saber.name, "光束军刀", "第一个武器应为光束军刀")
	assert_eq(rifle.name, "步枪", "第二个武器应为步枪")


func test_complete_unit_instance_creation() -> void:
	# 创建完整的单位实例
	var instance = UnitInstanceScript.new()
	instance.initialize(_player_unit, _player_pilot)

	assert_eq(instance.unit_data.name, "RX-78 高达", "单位名称应为 RX-78 高达")
	assert_eq(instance.pilot_data.name, "阿姆罗", "驾驶员名称应为阿姆罗")
	assert_eq(instance.current_hp, instance.get_max_hp(), "初始 HP 应等于最大 HP")
	assert_eq(instance.current_en, instance.get_max_en(), "初始 EN 应等于最大 EN")


func test_enemy_unit_instance_creation() -> void:
	var instance = UnitInstanceScript.new()
	instance.initialize(_enemy_unit, _enemy_pilot)

	assert_eq(instance.unit_data.name, "MS-06 扎克II", "单位名称应为 MS-06 扎克II")
	assert_eq(instance.pilot_data.name, "夏亚", "驾驶员名称应为夏亚")
	assert_true(instance.is_enemy(), "敌方单位应标记为敌方")


func test_faction_relationship() -> void:
	assert_false(_player_pilot.is_same_faction(_enemy_pilot), "玩家和敌方不应同阵营")
	assert_true(_player_pilot.is_same_faction(_player_pilot), "相同驾驶员应同阵营")