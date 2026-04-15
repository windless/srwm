## ActionMenu
## 单位行动菜单组件
## 继承 MenuPanel，提供单位行动选项（移动、攻击、精神指令、待机）

class_name ActionMenu
extends MenuPanel

## 信号：行动被选中
signal action_selected(action_type: int)

## 行动类型枚举
enum ActionType {
	MOVE,
	ATTACK,
	SPIRIT,
	WAIT
}

## 当前选中单位
var _current_unit: UnitInstance = null

## 单位是否已移动（临时状态，后续由回合系统管理）
var _unit_has_moved: bool = false

## 单位是否有攻击目标（临时状态，后续由战斗系统管理）
var _unit_has_targets: bool = true


func _ready() -> void:
	super._ready()
	# 连接父类选项选中信号
	option_selected.connect(_on_option_selected)


## 设置当前单位并生成行动选项
## unit: UnitInstance 选中单位，null 表示隐藏菜单
func set_unit(unit: UnitInstance) -> void:
	_current_unit = unit

	if unit == null:
		hide_menu()
		return

	# 根据单位类型生成行动选项
	var options: Array[Dictionary] = _generate_action_options(unit)
	set_options(options)

	# 显示菜单
	show_menu()


## 生成行动选项列表
func _generate_action_options(unit: UnitInstance) -> Array[Dictionary]:
	var options: Array[Dictionary] = []

	if unit.is_enemy():
		# 敌方单位：有限选项
		options.append({
			"name": "Attack",
			"enabled": _unit_has_targets,
			"action": ActionType.ATTACK
		})
		options.append({
			"name": "Wait",
			"enabled": true,
			"action": ActionType.WAIT
		})
	else:
		# 玩家单位：完整选项
		options.append({
			"name": "Move",
			"enabled": not _unit_has_moved,
			"action": ActionType.MOVE
		})
		options.append({
			"name": "Attack",
			"enabled": _unit_has_targets,
			"action": ActionType.ATTACK
		})
		options.append({
			"name": "Spirit",
			"enabled": true,  # 精神指令默认可用
			"action": ActionType.SPIRIT
		})
		options.append({
			"name": "Wait",
			"enabled": true,
			"action": ActionType.WAIT
		})

	return options


## 选项选中回调
func _on_option_selected(index: int) -> void:
	if _current_unit == null:
		return

	# 获取选中的行动类型
	var option: Dictionary = get_option(index)
	var action_type: ActionType = option.get("action", ActionType.WAIT)

	# 发出行动选中信号
	emit_signal("action_selected", action_type)

	# 选择后隐藏菜单
	hide_menu()


## 设置单位移动状态
func set_unit_moved(has_moved: bool) -> void:
	_unit_has_moved = has_moved
	# 如果当前有单位，更新选项状态
	if _current_unit != null:
		var options: Array[Dictionary] = _generate_action_options(_current_unit)
		set_options(options)


## 设置单位攻击目标状态
func set_unit_has_targets(has_targets: bool) -> void:
	_unit_has_targets = has_targets
	# 如果当前有单位，更新选项状态
	if _current_unit != null:
		var options: Array[Dictionary] = _generate_action_options(_current_unit)
		set_options(options)


## 获取当前单位
func get_current_unit() -> UnitInstance:
	return _current_unit


## 清除单位选择
func clear_unit() -> void:
	_current_unit = null
	_unit_has_moved = false
	_unit_has_targets = true
	hide_menu()