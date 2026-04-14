## WeaponData.gd
## 武器数据模板，定义武器的基础属性
## 使用 Resource 格式存储，便于编辑和版本控制

class_name WeaponData
extends Resource

## 武器类型枚举
enum WeaponType {
	PHYSICAL,   ## 物理/格斗类武器
	SHOOTING,   ## 射击类武器
	SPECIAL     ## 特殊武器
}

## 武器名称
@export var name: String = ""

## 攻击力
@export var power: int = 100

## 最小射程（网格距离）
@export var range_min: int = 1

## 最大射程（网格距离）
@export var range_max: int = 1

## EN 消耗
@export var en_cost: int = 0

## 基础命中率（百分比）
@export var accuracy: int = 100

## 武器类型
@export var type: WeaponType = WeaponType.PHYSICAL