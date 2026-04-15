## MenuPanel
## 可复用的移动端触控友好菜单面板基础组件
## 支持动态选项列表、可用状态切换和显示/隐藏动画

class_name MenuPanel
extends PanelContainer

## 信号：选项被选中
signal option_selected(index: int)

## 选项字体大小
@export var option_font_size: int = 18

## 动画持续时间
@export var animation_duration: float = 0.15

## 选项按钮最小高度（触控友好）
@export var option_min_height: float = 48.0

## 选项间距
@export var option_spacing: int = 8

## 当前选项列表
var _options: Array[Dictionary] = []

## 选项按钮容器
var _button_container: VBoxContainer

## 选项按钮列表
var _option_buttons: Array[Button] = []

## 显示/隐藏动画 Tween
var _visibility_tween: Tween


func _ready() -> void:
	_setup_container()
	hide()


## 设置容器结构
func _setup_container() -> void:
	# 创建 VBoxContainer 作为按钮容器
	_button_container = VBoxContainer.new()
	_button_container.alignment = BoxContainer.ALIGNMENT_CENTER
	_button_container.add_theme_constant_override("separation", option_spacing)
	add_child(_button_container)


## 设置菜单选项
## options: Array[Dictionary] 每个字典包含 {name: String, enabled: bool}
func set_options(options: Array[Dictionary]) -> void:
	_options = options
	_rebuild_buttons()


## 重建选项按钮列表
func _rebuild_buttons() -> void:
	# 清除现有按钮
	for button in _option_buttons:
		if is_instance_valid(button):
			button.queue_free()
	_option_buttons.clear()

	# 创建新按钮
	for i in range(_options.size()):
		var option: Dictionary = _options[i]
		var button: Button = _create_option_button(i, option)
		_button_container.add_child(button)
		_option_buttons.append(button)


## 创建单个选项按钮
func _create_option_button(index: int, option: Dictionary) -> Button:
	var button: Button = Button.new()
	button.custom_minimum_size = Vector2(100, option_min_height)
	button.text = option.get("name", "Option")

	# 设置字体大小
	button.add_theme_font_size_override("font_size", option_font_size)

	# 设置可用状态
	var enabled: bool = option.get("enabled", true)
	button.disabled = not enabled

	# 连接按钮信号
	button.pressed.connect(_on_option_button_pressed.bind(index))

	return button


## 选项按钮按下回调
func _on_option_button_pressed(index: int) -> void:
	# 检查选项是否可用
	if index >= 0 and index < _options.size():
		var option: Dictionary = _options[index]
		if option.get("enabled", true):
			emit_signal("option_selected", index)


## 显示菜单（带动画）
func show_menu() -> void:
	show()

	# 取消之前的动画
	if _visibility_tween != null and _visibility_tween.is_valid():
		_visibility_tween.kill()

	# 创建淡入动画
	_visibility_tween = create_tween()
	_visibility_tween.set_ease(Tween.EASE_OUT)
	_visibility_tween.set_trans(Tween.TRANS_QUAD)

	# 从透明到完全可见
	modulate.a = 0.0
	_visibility_tween.tween_property(self, "modulate:a", 1.0, animation_duration)


## 隐藏菜单（带动画）
func hide_menu() -> void:
	# 取消之前的动画
	if _visibility_tween != null and _visibility_tween.is_valid():
		_visibility_tween.kill()

	# 创建淡出动画
	_visibility_tween = create_tween()
	_visibility_tween.set_ease(Tween.EASE_IN)
	_visibility_tween.set_trans(Tween.TRANS_QUAD)

	_visibility_tween.tween_property(self, "modulate:a", 0.0, animation_duration)
	_visibility_tween.tween_callback(hide)


## 获取选项数量
func get_option_count() -> int:
	return _options.size()


## 获取指定索引的选项
func get_option(index: int) -> Dictionary:
	if index >= 0 and index < _options.size():
		return _options[index]
	return {}


## 更新指定选项的可用状态
func set_option_enabled(index: int, enabled: bool) -> void:
	if index >= 0 and index < _options.size():
		_options[index]["enabled"] = enabled
		if index < _option_buttons.size():
			_option_buttons[index].disabled = not enabled