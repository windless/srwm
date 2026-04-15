class_name TestMenuPanel
extends GutTest

## MenuPanel 测试场景路径
const MENU_PANEL_SCENE: String = "res://scenes/ui/menu_panel.tscn"

## 测试用的 MenuPanel 实例
var _menu_panel: MenuPanel


func before_each() -> void:
	# 创建 MenuPanel 实例
	_menu_panel = autofree(load(MENU_PANEL_SCENE).instantiate())
	add_child(_menu_panel)


func test_initial_state() -> void:
	# 验证初始状态
	assert_false(_menu_panel.visible, "MenuPanel should be hidden initially")
	assert_eq(_menu_panel.get_option_count(), 0, "Option count should be 0 initially")


func test_set_options() -> void:
	# 设置选项列表
	var options: Array[Dictionary] = [
		{"name": "Option 1", "enabled": true},
		{"name": "Option 2", "enabled": false},
		{"name": "Option 3", "enabled": true}
	]
	_menu_panel.set_options(options)

	assert_eq(_menu_panel.get_option_count(), 3, "Option count should be 3 after set_options")


func test_set_options_replaces_existing() -> void:
	# 设置第一批选项
	var options1: Array[Dictionary] = [
		{"name": "A", "enabled": true}
	]
	_menu_panel.set_options(options1)
	assert_eq(_menu_panel.get_option_count(), 1)

	# 设置第二批选项（应替换）
	var options2: Array[Dictionary] = [
		{"name": "B", "enabled": true},
		{"name": "C", "enabled": true}
	]
	_menu_panel.set_options(options2)

	assert_eq(_menu_panel.get_option_count(), 2, "Options should be replaced, not appended")


func test_show_menu() -> void:
	# 显示菜单
	_menu_panel.show_menu()

	# 等待动画完成
	await wait_seconds(0.2)

	assert_true(_menu_panel.visible, "MenuPanel should be visible after show_menu")


func test_hide_menu() -> void:
	# 先显示
	_menu_panel.show_menu()
	await wait_seconds(0.2)
	assert_true(_menu_panel.visible)

	# 隐藏
	_menu_panel.hide_menu()
	await wait_seconds(0.2)

	assert_false(_menu_panel.visible, "MenuPanel should be hidden after hide_menu")


func test_option_selected_signal() -> void:
	# 设置选项
	var options: Array[Dictionary] = [
		{"name": "Option 1", "enabled": true},
		{"name": "Option 2", "enabled": true}
	]
	_menu_panel.set_options(options)
	_menu_panel.show_menu()

	# 监听信号
	watch_signals(_menu_panel)

	# 模拟按钮点击（通过调用内部回调）
	_menu_panel._on_option_button_pressed(0)

	# 验证信号发射
	assert_signal_emitted(_menu_panel, "option_selected")
	assert_signal_emitted_with_parameters(_menu_panel, "option_selected", [0])


func test_disabled_option_no_signal() -> void:
	# 设置选项（第一个禁用）
	var options: Array[Dictionary] = [
		{"name": "Disabled", "enabled": false},
		{"name": "Enabled", "enabled": true}
	]
	_menu_panel.set_options(options)

	# 监听信号
	watch_signals(_menu_panel)

	# 模拟点击禁用选项
	_menu_panel._on_option_button_pressed(0)

	# 信号不应发射
	assert_signal_not_emitted(_menu_panel, "option_selected")


func test_get_option() -> void:
	var options: Array[Dictionary] = [
		{"name": "Test", "enabled": true}
	]
	_menu_panel.set_options(options)

	var option: Dictionary = _menu_panel.get_option(0)
	assert_eq(option["name"], "Test", "get_option should return correct option")


func test_get_option_invalid_index() -> void:
	var options: Array[Dictionary] = [
		{"name": "Test", "enabled": true}
	]
	_menu_panel.set_options(options)

	# 越界索引应返回空字典
	var option: Dictionary = _menu_panel.get_option(10)
	assert_eq(option.size(), 0, "get_option with invalid index should return empty dict")


func test_set_option_enabled() -> void:
	var options: Array[Dictionary] = [
		{"name": "Test", "enabled": true}
	]
	_menu_panel.set_options(options)

	# 设置为禁用
	_menu_panel.set_option_enabled(0, false)
	var option: Dictionary = _menu_panel.get_option(0)
	assert_false(option["enabled"], "Option should be disabled after set_option_enabled")

	# 设置为启用
	_menu_panel.set_option_enabled(0, true)
	option = _menu_panel.get_option(0)
	assert_true(option["enabled"], "Option should be enabled after set_option_enabled")