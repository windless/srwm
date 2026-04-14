## UnitInstance.gd
## 单位运行时状态管理
## 引用 UnitData 和 PilotData，管理变化状态（HP、EN）

class_name UnitInstance
extends RefCounted

## 机甲数据模板
var unit_data: UnitData

## 驾驶员数据模板
var pilot_data: PilotData

## 当前 HP
var current_hp: int

## 当前 EN
var current_en: int


## 初始化单位实例
## 从 UnitData 和 PilotData 加载初始状态
func initialize(p_unit_data: UnitData, p_pilot_data: PilotData) -> void:
	unit_data = p_unit_data
	pilot_data = p_pilot_data

	# 根据驾驶员等级计算实际 HP/EN
	current_hp = _calculate_hp()
	current_en = _calculate_en()


## 计算实际最大 HP（基础值 + 成长）
func _calculate_hp() -> int:
	var base_hp := unit_data.max_hp
	var growth := pilot_data.hp_growth
	var level_bonus := pilot_data.level - 1
	return int(base_hp * (1.0 + growth * level_bonus))


## 计算实际最大 EN（基础值 + 成长）
func _calculate_en() -> int:
	var base_en := unit_data.max_en
	var growth := pilot_data.en_growth
	var level_bonus := pilot_data.level - 1
	return int(base_en * (1.0 + growth * level_bonus))


## 获取计算后的最大 HP
func get_max_hp() -> int:
	return _calculate_hp()


## 获取计算后的最大 EN
func get_max_en() -> int:
	return _calculate_en()


## 判断是否为敌方阵营
func is_enemy() -> bool:
	return pilot_data.is_enemy()


## 判断是否为友方阵营
func is_friendly() -> bool:
	return pilot_data.is_friendly()


## 判断与另一个单位是否敌对
func is_hostile_to(other: UnitInstance) -> bool:
	if other == null:
		return false
	return pilot_data.faction != other.pilot_data.faction \
		and not (is_friendly() and other.is_friendly())


## 判断单位是否存活
func is_alive() -> bool:
	return current_hp > 0