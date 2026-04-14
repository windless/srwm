## test_weapon_data.gd
## 测试 WeaponData Resource 加载和属性

class_name TestWeaponData
extends GutTest

# 预加载类定义脚本（GUT 在 Godot 4 中需要）
var WeaponDataScript := preload("res://scripts/weapons/weapon_data.gd")

var beam_saber
var rifle


func before_all() -> void:
	beam_saber = load("res://resources/weapons/beam_saber.tres")
	rifle = load("res://resources/weapons/rifle.tres")


func test_weapon_data_loaded() -> void:
	assert_not_null(beam_saber, "光束军刀数据应加载成功")
	assert_not_null(rifle, "步枪数据应加载成功")


func test_weapon_name() -> void:
	assert_eq(beam_saber.name, "光束军刀", "光束军刀名称应为光束军刀")
	assert_eq(rifle.name, "步枪", "步枪名称应为步枪")


func test_weapon_power() -> void:
	assert_eq(beam_saber.power, 150, "光束军刀攻击力应为 150")
	assert_eq(rifle.power, 120, "步枪攻击力应为 120")


func test_weapon_range() -> void:
	assert_eq(beam_saber.range_min, 1, "光束军刀最小射程应为 1")
	assert_eq(beam_saber.range_max, 1, "光束军刀最大射程应为 1")
	assert_eq(rifle.range_min, 2, "步枪最小射程应为 2")
	assert_eq(rifle.range_max, 5, "步枪最大射程应为 5")


func test_weapon_en_cost() -> void:
	assert_eq(beam_saber.en_cost, 5, "光束军刀 EN 消耗应为 5")
	assert_eq(rifle.en_cost, 10, "步枪 EN 消耗应为 10")


func test_weapon_accuracy() -> void:
	assert_eq(beam_saber.accuracy, 90, "光束军刀命中率应为 90")
	assert_eq(rifle.accuracy, 85, "步枪命中率应为 85")


func test_weapon_type() -> void:
	# WeaponType.PHYSICAL = 0, WeaponType.SHOOTING = 1
	assert_eq(beam_saber.type, 0, "光束军刀类型应为 PHYSICAL")
	assert_eq(rifle.type, 1, "步枪类型应为 SHOOTING")