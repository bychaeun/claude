extends Node

@onready var _mirror_monster: Sprite2D = $MirrorMonster
@onready var _eye_wall: Node2D = $EyeWall
@onready var _crt: ColorRect = $CRTOverlay/CRTRect

func _ready() -> void:
	_mirror_monster.modulate.a = 0.0
	_eye_wall.hide()
	_run_sequence()

func _run_sequence() -> void:
	await get_tree().create_timer(0.8).timeout
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player and player.has_method("freeze"):
		player.freeze()
		var tw1 := create_tween()
		tw1.tween_property(player, "global_position", Vector2(180.0, 370.0), 2.2) \
			.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		await tw1.finished

	await get_tree().create_timer(0.4).timeout

	var tw2 := create_tween()
	tw2.tween_property(_mirror_monster, "modulate:a", 1.0, 1.8)
	await tw2.finished

	await get_tree().create_timer(0.5).timeout

	_eye_wall.show()
	AudioManager.play_sfx("heartbeat")

	await get_tree().create_timer(0.8).timeout

	DialogueManager.show_dialogue("ending_final")
	await DialogueManager.dialogue_finished

	if _crt and _crt.has_method("set_intensity"):
		var tw3 := create_tween()
		tw3.tween_method(_crt.set_intensity, 0.3, 1.0, 2.0)
		await tw3.finished

	await get_tree().create_timer(1.2).timeout
	RoomManager.go_to_title()
