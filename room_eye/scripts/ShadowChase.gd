extends CharacterBody2D

const SPEED: float = 55.0
const CATCH_DIST: float = 20.0
const SPAWN_OFFSET_X: float = 340.0

var _chasing: bool = false
var _player: Node2D = null

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("shadow_trigger")
	hide()

func start_chase() -> void:
	_player = get_tree().get_first_node_in_group("player")
	if _player == null:
		return
	global_position = _player.global_position + Vector2(SPAWN_OFFSET_X, 0.0)
	show()
	_chasing = true
	_sprite.play("walk")

func _physics_process(_delta: float) -> void:
	if not _chasing or _player == null:
		return

	var dir := (_player.global_position - global_position).normalized()
	velocity = dir * SPEED
	_sprite.flip_h = dir.x < 0.0
	move_and_slide()

	if global_position.distance_to(_player.global_position) < CATCH_DIST:
		_on_caught()

func _on_caught() -> void:
	_chasing = false
	if _player.has_method("freeze"):
		_player.freeze()

	DialogueManager.show_dialogue("shadow_caught")
	DialogueManager.dialogue_finished.connect(
		func() -> void: get_tree().reload_current_scene(),
		CONNECT_ONE_SHOT
	)

func stop_chase() -> void:
	_chasing = false
	hide()
