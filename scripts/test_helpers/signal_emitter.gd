class_name SignalEmitter
extends Node

## 测试信号发射器，模拟 UnitInstance 的各种状态信号

# === 模拟 UnitInstance 信号 ===
signal deployed()
signal airborne_changed(is_airborne: bool)
signal action_started(action_type: String)
signal action_completed()
signal hit_received()
signal destroyed()
signal disabled_changed(is_disabled: bool)
signal exiting()

# === 信号发射方法 ===
func emit_deployed() -> void:
	deployed.emit()
	print("[SignalEmitter] 发出 deployed 信号")

func emit_airborne_changed(is_airborne: bool) -> void:
	airborne_changed.emit(is_airborne)
	print("[SignalEmitter] 发出 airborne_changed 信号: %s" % is_airborne)

func emit_action_started(action_type: String) -> void:
	action_started.emit(action_type)
	print("[SignalEmitter] 发出 action_started 信号: %s" % action_type)

func emit_action_completed() -> void:
	action_completed.emit()
	print("[SignalEmitter] 发出 action_completed 信号")

func emit_hit_received() -> void:
	hit_received.emit()
	print("[SignalEmitter] 发出 hit_received 信号")

func emit_destroyed() -> void:
	destroyed.emit()
	print("[SignalEmitter] 发出 destroyed 信号")

func emit_disabled_changed(is_disabled: bool) -> void:
	disabled_changed.emit(is_disabled)
	print("[SignalEmitter] 发出 disabled_changed 信号: %s" % is_disabled)

func emit_exiting() -> void:
	exiting.emit()
	print("[SignalEmitter] 发出 exiting 信号")