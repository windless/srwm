class_name TestUnitRenderer
extends Node2D

## UnitRenderer 测试场景控制器

# === 状态变量 ===
var _is_airborne: bool = false
var _is_disabled: bool = false

# === 节点引用 ===
@onready var unit_renderer: UnitRenderer = $UnitRenderer
@onready var signal_emitter: SignalEmitter = $SignalEmitter

# === 按钮引用 ===
@onready var btn_deployed: Button = $UIPanel/VBoxContainer/AnimationButtons/BtnDeployed
@onready var btn_takeoff: Button = $UIPanel/VBoxContainer/AnimationButtons/BtnTakeoff
@onready var btn_idle: Button = $UIPanel/VBoxContainer/AnimationButtons/BtnIdle
@onready var btn_move: Button = $UIPanel/VBoxContainer/AnimationButtons/BtnMove
@onready var btn_attack: Button = $UIPanel/VBoxContainer/AnimationButtons/BtnAttack
@onready var btn_hit: Button = $UIPanel/VBoxContainer/AnimationButtons/BtnHit
@onready var btn_land: Button = $UIPanel/VBoxContainer/AnimationButtons/BtnLand
@onready var btn_destroy: Button = $UIPanel/VBoxContainer/AnimationButtons/BtnDestroy
@onready var btn_exit: Button = $UIPanel/VBoxContainer/AnimationButtons/BtnExit

@onready var btn_airborne: Button = $UIPanel/VBoxContainer/StateButtons/BtnAirborne
@onready var btn_disabled: Button = $UIPanel/VBoxContainer/StateButtons/BtnDisabled

@onready var btn_south: Button = $UIPanel/VBoxContainer/DirectionButtons/BtnSouth
@onready var btn_east: Button = $UIPanel/VBoxContainer/DirectionButtons/BtnEast
@onready var btn_north: Button = $UIPanel/VBoxContainer/DirectionButtons/BtnNorth
@onready var btn_west: Button = $UIPanel/VBoxContainer/DirectionButtons/BtnWest

@onready var lbl_status: Label = $UIPanel/VBoxContainer/LblStatus

# === 生命周期方法 ===
func _ready() -> void:
	_connect_buttons()
	_connect_renderer_signals()

	# 连接信号发射器到渲染器
	unit_renderer.connect_to_unit_instance(signal_emitter)

	_update_status_label()

func _connect_buttons() -> void:
	# 动画信号按钮
	btn_deployed.pressed.connect(_on_btn_deployed_pressed)
	btn_takeoff.pressed.connect(_on_btn_takeoff_pressed)
	btn_idle.pressed.connect(_on_btn_idle_pressed)
	btn_move.pressed.connect(_on_btn_move_pressed)
	btn_attack.pressed.connect(_on_btn_attack_pressed)
	btn_hit.pressed.connect(_on_btn_hit_pressed)
	btn_land.pressed.connect(_on_btn_land_pressed)
	btn_destroy.pressed.connect(_on_btn_destroy_pressed)
	btn_exit.pressed.connect(_on_btn_exit_pressed)

	# 状态切换按钮
	btn_airborne.pressed.connect(_on_btn_airborne_pressed)
	btn_disabled.pressed.connect(_on_btn_disabled_pressed)

	# 方向切换按钮
	btn_south.pressed.connect(_on_btn_south_pressed)
	btn_east.pressed.connect(_on_btn_east_pressed)
	btn_north.pressed.connect(_on_btn_north_pressed)
	btn_west.pressed.connect(_on_btn_west_pressed)

func _connect_renderer_signals() -> void:
	unit_renderer.animation_completed.connect(_on_animation_completed)
	unit_renderer.exit_completed.connect(_on_exit_completed)

# === 动画信号按钮回调 ===
func _on_btn_deployed_pressed() -> void:
	signal_emitter.emit_deployed()

func _on_btn_takeoff_pressed() -> void:
	_is_airborne = true
	signal_emitter.emit_airborne_changed(true)

func _on_btn_idle_pressed() -> void:
	signal_emitter.emit_action_completed()

func _on_btn_move_pressed() -> void:
	signal_emitter.emit_action_started("move")

func _on_btn_attack_pressed() -> void:
	signal_emitter.emit_action_started("attack")

func _on_btn_hit_pressed() -> void:
	signal_emitter.emit_hit_received()

func _on_btn_land_pressed() -> void:
	_is_airborne = false
	signal_emitter.emit_airborne_changed(false)

func _on_btn_destroy_pressed() -> void:
	signal_emitter.emit_destroyed()

func _on_btn_exit_pressed() -> void:
	signal_emitter.emit_exiting()

# === 状态切换按钮回调 ===
func _on_btn_airborne_pressed() -> void:
	_is_airborne = not _is_airborne
	signal_emitter.emit_airborne_changed(_is_airborne)
	btn_airborne.text = "Airborne: %s" % _is_airborne
	_update_status_label()

func _on_btn_disabled_pressed() -> void:
	_is_disabled = not _is_disabled
	signal_emitter.emit_disabled_changed(_is_disabled)
	btn_disabled.text = "Disabled: %s" % _is_disabled
	_update_status_label()

# === 方向切换按钮回调 ===
func _on_btn_south_pressed() -> void:
	unit_renderer.set_direction(UnitRenderer.Direction.SOUTH)
	_update_status_label()

func _on_btn_east_pressed() -> void:
	unit_renderer.set_direction(UnitRenderer.Direction.EAST)
	_update_status_label()

func _on_btn_north_pressed() -> void:
	unit_renderer.set_direction(UnitRenderer.Direction.NORTH)
	_update_status_label()

func _on_btn_west_pressed() -> void:
	unit_renderer.set_direction(UnitRenderer.Direction.WEST)
	_update_status_label()

# === 渲染器信号回调 ===
func _on_animation_completed(anim_name: String) -> void:
	print("[TestUnitRenderer] 动画完成: %s" % anim_name)
	_update_status_label()

func _on_exit_completed() -> void:
	print("[TestUnitRenderer] 离场完成")

# === 状态显示更新 ===
func _update_status_label() -> void:
	var dir_name: String = UnitRenderer.Direction.keys()[unit_renderer.direction]
	lbl_status.text = "方向: %s | Airborne: %s | Disabled: %s" % [dir_name, _is_airborne, _is_disabled]