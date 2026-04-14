## BattleHUD
## 战场 HUD 界面系统
## 显示单位信息、回合状态、操作按钮
## 支持移动端触控友好的 UI 设计

class_name BattleHUD
extends CanvasLayer

## 单位信息面板节点
@export var unit_info_panel: Control

## 单位名称标签
@export var unit_name_label: Label

## 单位 HP 标签
@export var unit_hp_label: Label

## 单位 EN 标签
@export var unit_en_label: Label

## 驾驶员名称标签
@export var pilot_name_label: Label

## 操作按钮容器
@export var action_buttons_container: Control

## 移动按钮
@export var move_button: Button

## 攻击按钮
@export var attack_button: Button

## 待机按钮
@export var wait_button: Button

## 当前选中的单位
var _selected_unit: UnitInstance = null

## 是否选中玩家单位
var _is_player_unit_selected: bool = false


func _ready() -> void:
	# 初始化 UI 状态
	hide_unit_info()
	hide_action_buttons()

	# 连接按钮信号
	if move_button != null:
		move_button.pressed.connect(_on_move_button_pressed)
	if attack_button != null:
		attack_button.pressed.connect(_on_attack_button_pressed)
	if wait_button != null:
		wait_button.pressed.connect(_on_wait_button_pressed)


## 显示单位信息
func show_unit_info(unit: UnitInstance) -> void:
	if unit == null:
		return

	_selected_unit = unit
	_is_player_unit_selected = not unit.is_enemy()

	# 显示单位信息面板
	if unit_info_panel != null:
		unit_info_panel.visible = true

	# 更新单位名称
	if unit_name_label != null:
		unit_name_label.text = unit.unit_data.name

	# 更新 HP 信息
	if unit_hp_label != null:
		var max_hp: int = unit.get_max_hp()
		unit_hp_label.text = "HP: %d/%d" % [unit.current_hp, max_hp]

	# 敌方单位只显示名称和 HP
	if unit.is_enemy():
		if unit_en_label != null:
			unit_en_label.visible = false
		if pilot_name_label != null:
			pilot_name_label.visible = false
	else:
		# 玩家单位显示完整信息
		if unit_en_label != null:
			var max_en: int = unit.get_max_en()
			unit_en_label.text = "EN: %d/%d" % [unit.current_en, max_en]
			unit_en_label.visible = true

		if pilot_name_label != null:
			pilot_name_label.text = "Pilot: %s" % unit.pilot_data.name
			pilot_name_label.visible = true


## 隐藏单位信息
func hide_unit_info() -> void:
	_selected_unit = null
	_is_player_unit_selected = false

	if unit_info_panel != null:
		unit_info_panel.visible = false


## 显示操作按钮（仅玩家单位）
func show_action_buttons() -> void:
	if not _is_player_unit_selected:
		return

	if action_buttons_container != null:
		action_buttons_container.visible = true


## 隐藏操作按钮
func hide_action_buttons() -> void:
	if action_buttons_container != null:
		action_buttons_container.visible = false


## 处理单位选择变化
func on_unit_selection_changed(unit: UnitInstance) -> void:
	if unit == null:
		hide_unit_info()
		hide_action_buttons()
	else:
		show_unit_info(unit)
		if not unit.is_enemy():
			show_action_buttons()
		else:
			hide_action_buttons()


## 处理单位 HP 变化
func on_unit_hp_changed(unit: UnitInstance) -> void:
	if unit == _selected_unit:
		# 更新 HP 显示
		if unit_hp_label != null:
			var max_hp: int = unit.get_max_hp()
			unit_hp_label.text = "HP: %d/%d" % [unit.current_hp, max_hp]


## 移动按钮按下回调
func _on_move_button_pressed() -> void:
	# TODO: 实现移动逻辑
	print("Move button pressed for unit: %s" % _selected_unit.unit_data.name)


## 攻击按钮按下回调
func _on_attack_button_pressed() -> void:
	# TODO: 实现攻击逻辑
	print("Attack button pressed for unit: %s" % _selected_unit.unit_data.name)


## 待机按钮按下回调
func _on_wait_button_pressed() -> void:
	# TODO: 实现待机逻辑
	print("Wait button pressed for unit: %s" % _selected_unit.unit_data.name)
	# 选择待机后清除选择
	hide_unit_info()
	hide_action_buttons()