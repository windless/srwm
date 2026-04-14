## UnitData.gd
## 机甲单位数据模板，定义机甲的基础属性和武器装备
## 使用 Resource 格式存储，运行时通过 UnitInstance 实例化

class_name UnitData
extends Resource

## 机甲名称
@export var name: String = ""

## 最大 HP
@export var max_hp: int = 100

## 最大 EN
@export var max_en: int = 50

## 装甲值
@export var armor: int = 10

## 机动值
@export var mobility: int = 5

## 武器列表（引用 WeaponData）
@export var weapons: Array[WeaponData] = []