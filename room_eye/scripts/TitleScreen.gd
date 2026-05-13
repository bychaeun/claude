extends Node2D

@onready var _start_btn: Button = $CanvasLayer/VBox/StartButton

func _ready() -> void:
	_start_btn.pressed.connect(_on_start)
	AudioManager.play_music("noise", true)

func _on_start() -> void:
	RoomManager.start_game()
