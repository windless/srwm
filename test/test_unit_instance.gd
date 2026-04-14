## test_unit_instance.gd
## 测试 UnitInstance 初始化和状态管理

class_name TestUnitInstance
extends GutTest

# 预加载类定义脚本（GUT 在 Godot 4 中需要）
var UnitDataScript := preload("res://scripts/units/unit_data.gd")
var PilotDataScript := preload("res://scripts/pilots/pilot_data.gd")
var UnitInstanceScript := preload("res://scripts/units/unit_instance.gd")

var player_unit_data
var player_pilot_data
var enemy_unit_data
var enemy_pilot_data

var player_instance
var enemy_instance


func before_all() -> void:
	player_unit_data = load("res://resources/units/example_player.tres")
	player_pilot_data = load("res://resources/pilots/example_player_pilot.tres")
	enemy_unit_data = load("res://resources/units/example_enemy.tres")
	enemy_pilot_data = load("res://resources/pilots/example_enemy_pilot.tres")


func before_each() -> void:
	player_instance = UnitInstanceScript.new()
	player_instance.initialize(player_unit_data, player_pilot_data)
	enemy_instance = UnitInstanceScript.new()
	enemy_instance.initialize(enemy_unit_data, enemy_pilot_data)


func test_unit_instance_initialized() -> void:
	assert_not_null(player_instance.unit_data, "UnitInstance 应有 unit_data 引用")
	assert_not_null(player_instance.pilot_data, "UnitInstance 应有 pilot_data 引用")


func test_current_hp_en_initialized() -> void:
	assert_gt(player_instance.current_hp, 0, "当前 HP 应大于 0")
	assert_gt(player_instance.current_en, 0, "当前 EN 应大于 0")


func test_calculated_hp_with_level() -> void:
	# 等级 1: base_hp * (1 + 0.1 * 0) = base_hp
	assert_eq(player_instance.get_max_hp(), 200, "等级 1 时 HP 应等于基础值")

	# 等级 5: base_hp * (1 + 0.08 * 4) = 150 * 1.32 = 198
	assert_eq(enemy_instance.get_max_hp(), 198, "等级 5 时 HP 应有成长加成")


func test_calculated_en_with_level() -> void:
	# 等级 1: base_en * (1 + 0.05 * 0) = base_en
	assert_eq(player_instance.get_max_en(), 100, "等级 1 时 EN 应等于基础值")


func test_is_enemy_method() -> void:
	assert_false(player_instance.is_enemy(), "玩家单位不应是敌方")
	assert_true(enemy_instance.is_enemy(), "敌方单位应是敌方")


func test_is_friendly_method() -> void:
	assert_true(player_instance.is_friendly(), "玩家单位应是友方")


func test_is_hostile_to() -> void:
	assert_true(player_instance.is_hostile_to(enemy_instance), "玩家和敌方应互为敌对")
	assert_false(player_instance.is_hostile_to(player_instance), "同单位不应敌对")


func test_is_alive() -> void:
	assert_true(player_instance.is_alive(), "初始状态应存活")
	player_instance.current_hp = 0
	assert_false(player_instance.is_alive(), "HP 为 0 时不应存活")