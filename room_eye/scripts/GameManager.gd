extends Node

# 0=관찰, 1=왜곡, 2=침식, 3=엔딩
var current_phase: int = 0
var investigate_count: int = 0

signal phase_changed(new_phase: int)

func reset() -> void:
	current_phase = 0
	investigate_count = 0
	emit_signal("phase_changed", 0)
