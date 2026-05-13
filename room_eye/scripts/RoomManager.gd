extends Node

var is_transitioning: bool = false

const ROOM_SCENES: PackedStringArray = [
	"res://scenes/rooms/Room1_Observe.tscn",
	"res://scenes/rooms/Room2_Distort.tscn",
	"res://scenes/rooms/Room3_Erode.tscn",
	"res://scenes/rooms/Room4_Ending.tscn",
]

# 타이틀에서 게임 시작
func start_game() -> void:
	if is_transitioning:
		return
	is_transitioning = true
	GameManager.reset()
	_fade_load(ROOM_SCENES[0])

# 현재 방 완료 → 다음 방으로
func go_next_room() -> void:
	if is_transitioning:
		return
	is_transitioning = true
	GameManager.current_phase += 1
	GameManager.investigate_count = 0
	if GameManager.current_phase >= ROOM_SCENES.size():
		go_to_title()
		return
	_fade_load(ROOM_SCENES[GameManager.current_phase])

# 타이틀로 귀환
func go_to_title() -> void:
	is_transitioning = true
	GameManager.reset()
	_fade_load("res://scenes/title/Title.tscn")

func _fade_load(path: String) -> void:
	var overlay := ColorRect.new()
	overlay.color = Color(0.0, 0.0, 0.0, 0.0)
	overlay.z_index = 200
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	get_tree().root.add_child(overlay)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)

	var tw := create_tween()
	tw.tween_property(overlay, "color:a", 1.0, 0.7)
	tw.tween_callback(func() -> void:
		overlay.queue_free()
		is_transitioning = false
		get_tree().change_scene_to_file(path)
	)
