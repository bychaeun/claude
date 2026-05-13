extends Node2D

# PhaseManager 가 call_group("phase2_objects","on_distort") 로 호출
func on_distort() -> void:
	for child in get_children():
		if child is Node2D:
			var offset := Vector2(randf_range(-22.0, 22.0), randf_range(-10.0, 10.0))
			var tw := create_tween()
			tw.tween_property(child, "position", child.position + offset, 1.2) \
				.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
