## test_unit_data.gd
## 测试 UnitData Resource 加载和属性

class_name TestUnitData
extends GutTest

# 预加载类定义脚本（GUT 在 Godot 4 中需要）
var WeaponDataScript := preload("res://scripts/weapons/weapon_data.gd")
var UnitDataScript := preload("res://scripts/units/unit_data.gd")

var player_unit
var enemy_unit


func before_all() -> void:
	player_unit = load("res://resources/units/example_player.tres")
	enemy_unit = load("res://resources/units/example_enemy.tres")


func test_unit_data_loaded() -> void:
	assert_not_null(player_unit, "玩家单位数据应加载成功")
	assert_not_null(enemy_unit, "敌方单位数据应加载成功")


func test_unit_name() -> void:
	assert_eq(player_unit.name, "RX-78 高达", "玩家单位名称应为 RX-78 高达")
	assert_eq(enemy_unit.name, "MS-06 扎克II", "敌方单位名称应为 MS-06 扎克II")


func test_unit_attributes() -> void:
	assert_eq(player_unit.max_hp, 200, "玩家单位最大 HP 应为 200")
	assert_eq(player_unit.max_en, 100, "玩家单位最大 EN 应为 100")
	assert_eq(player_unit.armor, 15, "玩家单位装甲应为 15")
	assert_eq(player_unit.mobility, 8, "玩家单位机动应为 8")


func test_unit_has_weapons() -> void:
	assert_eq(player_unit.weapons.size(), 2, "玩家单位应有 2 个武器")
	assert_eq(enemy_unit.weapons.size(), 2, "敌方单位应有 2 个武器")


func test_weapon_references_valid() -> void:
	for weapon in player_unit.weapons:
		assert_not_null(weapon, "武器引用应有效")