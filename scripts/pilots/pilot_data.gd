## PilotData.gd
## 驾驶员数据模板，定义驾驶员的基础属性
## 与 UnitData 分离，支持换乘系统

class_name PilotData
extends Resource

## 阵营枚举
enum Faction {
	PLAYER,   ## 玩家阵营
	ENEMY,    ## 敌方阵营
	NEUTRAL   ## 中立阵营
}

## 驾驶员名称
@export var name: String = ""

## 当前等级 (1-99)
@export_range(1, 99) var level: int = 1

## HP 成长率（百分比，如 0.1 表示每级 10%）
@export var hp_growth: float = 0.1

## EN 成长率（百分比）
@export var en_growth: float = 0.05

## 阵营归属
@export var faction: Faction = Faction.PLAYER


## 判断是否为敌方阵营
func is_enemy() -> bool:
	return faction == Faction.ENEMY


## 判断是否为友方阵营（玩家或中立）
func is_friendly() -> bool:
	return faction == Faction.PLAYER or faction == Faction.NEUTRAL


## 判断与另一个驾驶员是否同阵营
func is_same_faction(other: PilotData) -> bool:
	return faction == other.faction