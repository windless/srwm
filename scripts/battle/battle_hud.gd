## BattleHUD
## 战场 HUD 界面系统
## 显示单位信息、回合状态、行动菜单
## 支持移动端触控友好的 UI 设计

class_name BattleHUD
extends CanvasLayer

## 信号：行动请求（转发自 ActionMenu）
signal action_requested(action_type: int, unit: UnitInstance)

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

## ActionMenu 组件引用
@export var action_menu: ActionMenu

## 当前选中的单位
var _selected_unit: UnitInstance = null

## 是否选中玩家单位
var _is_player_unit_selected: bool = false


func _ready() -> void:
	# 初始化 UI 状态
	hide_unit_info()
	if action_menu != null:
		action_menu.hide_menu()

	# 连接 ActionMenu 信号
	if action_menu != null:
		action_menu.action_selected.connect(_on_action_selected)


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


## 显示行动菜单（仅玩家单位）
func show_action_menu() -> void:
	if not _is_player_unit_selected:
		return

	if action_menu != null:
		action_menu.set_unit(_selected_unit)


## 隐藏行动菜单
func hide_action_menu() -> void:
	if action_menu != null:
		action_menu.clear_unit()


## 处理单位选择变化
func on_unit_selection_changed(unit: UnitInstance) -> void:
	if unit == null:
		hide_unit_info()
		hide_action_menu()
	else:
		show_unit_info(unit)
		if not unit.is_enemy():
			show_action_menu()
		else:
			hide_action_menu()


## 处理单位 HP 变化
func on_unit_hp_changed(unit: UnitInstance) -> void:
	if unit == _selected_unit:
		# 更新 HP 显示
		if unit_hp_label != null:
			var max_hp: int = unit.get_max_hp()
			unit_hp_label.text = "HP: %d/%d" % [unit.current_hp, max_hp]


## ActionMenu 行动选中回调
func _on_action_selected(action_type: int) -> void:
	if _selected_unit != null:
		emit_signal("action_requested", action_type, _selected_unit)
		# 选择行动后隐藏菜单
		hide_action_menu()


## 获取当前选中单位
func get_selected_unit() -> UnitInstance:
	return _selected_unit