extends CharacterBody2D

const SPEED: float = 80.0
const ARRIVE_DIST: float = 5.0

var _target: Vector2 = Vector2.ZERO
var _moving: bool = false
var _frozen: bool = false

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("player")
	_target = global_position

func _unhandled_input(event: InputEvent) -> void:
	if _frozen or DialogueManager.is_open:
		return

	var world_pos := Vector2.ZERO
	var received := false

	if event is InputEventScreenTouch and (event as InputEventScreenTouch).pressed:
		var touch := event as InputEventScreenTouch
		world_pos = get_viewport().get_canvas_transform().affine_inverse() * touch.position
		received = true
	elif event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
			world_pos = get_global_mouse_position()
			received = true

	if received:
		_set_target(world_pos)

func _set_target(world_pos: Vector2) -> void:
	_target = world_pos
	_moving = true
	_sprite.flip_h = world_pos.x < global_position.x

func _physics_process(_delta: float) -> void:
	if _frozen:
		velocity = Vector2.ZERO
		return

	if not _moving:
		_play_anim("idle")
		return

	var diff := _target - global_position
	if diff.length() < ARRIVE_DIST:
		_moving = false
		velocity = Vector2.ZERO
		_play_anim("idle")
	else:
		velocity = diff.normalized() * SPEED
		_play_anim("walk")

	move_and_slide()

func _play_anim(anim: StringName) -> void:
	if _sprite.animation != anim:
		_sprite.play(anim)

func freeze() -> void:
	_frozen = true
	_moving = false
	velocity = Vector2.ZERO
	_play_anim("idle")

func unfreeze() -> void:
	_frozen = false
