## test_pilot_data.gd
## 测试 PilotData Resource 加载和属性

class_name TestPilotData
extends GutTest

# 预加载类定义脚本（GUT 在 Godot 4 中需要）
var PilotDataScript := preload("res://scripts/pilots/pilot_data.gd")

var player_pilot
var enemy_pilot


func before_all() -> void:
	player_pilot = load("res://resources/pilots/example_player_pilot.tres")
	enemy_pilot = load("res://resources/pilots/example_enemy_pilot.tres")


func test_pilot_data_loaded() -> void:
	assert_not_null(player_pilot, "玩家驾驶员数据应加载成功")
	assert_not_null(enemy_pilot, "敌方驾驶员数据应加载成功")


func test_pilot_name() -> void:
	assert_eq(player_pilot.name, "阿姆罗", "玩家驾驶员名称应为阿姆罗")
	assert_eq(enemy_pilot.name, "夏亚", "敌方驾驶员名称应为夏亚")


func test_pilot_level() -> void:
	assert_eq(player_pilot.level, 1, "玩家驾驶员等级应为 1")
	assert_eq(enemy_pilot.level, 5, "敌方驾驶员等级应为 5")


func test_pilot_growth() -> void:
	assert_almost_eq(player_pilot.hp_growth, 0.1, 0.001, "玩家驾驶员 HP 成长率应为 0.1")
	assert_almost_eq(player_pilot.en_growth, 0.05, 0.001, "玩家驾驶员 EN 成长率应为 0.05")


func test_pilot_faction() -> void:
	# Faction.PLAYER = 0, Faction.ENEMY = 1
	assert_eq(player_pilot.faction, 0, "玩家驾驶员阵营应为 PLAYER")
	assert_eq(enemy_pilot.faction, 1, "敌方驾驶员阵营应为 ENEMY")


func test_faction_methods() -> void:
	assert_false(player_pilot.is_enemy(), "玩家驾驶员不应是敌方")
	assert_true(enemy_pilot.is_enemy(), "敌方驾驶员应是敌方")
	assert_true(player_pilot.is_friendly(), "玩家驾驶员应是友方")