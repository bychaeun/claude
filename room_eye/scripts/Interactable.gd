extends Area2D

@export var dialogue_key: String = ""
@export var one_shot: bool = true
@export var triggers_room_exit: bool = false
## 방 이동을 위해 최소 조사 횟수가 필요한 경우 설정
@export var exit_requires_count: int = 0

var _used: bool = false
var _player_near: bool = false

@onready var _prompt: Label = $PromptLabel

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_prompt.hide()

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	_player_near = true
	if not (_used and one_shot):
		_prompt.show()

func _on_body_exited(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	_player_near = false
	_prompt.hide()

func _unhandled_input(event: InputEvent) -> void:
	if not _player_near:
		return
	if _used and one_shot:
		return
	if DialogueManager.is_open:
		return

	var pressed := false
	if event is InputEventScreenTouch and (event as InputEventScreenTouch).pressed:
		pressed = _touch_on_area((event as InputEventScreenTouch).position)
	elif event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
			pressed = true

	if pressed:
		get_viewport().set_input_as_handled()
		_investigate()

func _touch_on_area(screen_pos: Vector2) -> bool:
	var world_pos := get_viewport().get_canvas_transform().affine_inverse() * screen_pos
	var local_pos := to_local(world_pos)
	for child in get_children():
		if child is CollisionShape2D:
			var cs := child as CollisionShape2D
			if cs.shape is RectangleShape2D:
				return (cs.shape as RectangleShape2D).get_rect().has_point(local_pos)
	return true

func _investigate() -> void:
	if triggers_room_exit and GameManager.investigate_count < exit_requires_count:
		DialogueManager.show_dialogue(dialogue_key + "_locked")
		return

	if one_shot:
		_used = true
		_prompt.hide()

	DialogueManager.show_dialogue(dialogue_key)
	get_tree().call_group("phase_manager", "on_investigate", dialogue_key)

	if triggers_room_exit:
		DialogueManager.dialogue_finished.connect(
			func() -> void: RoomManager.go_next_room(),
			CONNECT_ONE_SHOT
		)
