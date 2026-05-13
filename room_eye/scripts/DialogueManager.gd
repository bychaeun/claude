extends CanvasLayer

var is_open: bool = false

var _queue: Array = []
var _index: int = 0
var _tween: Tween = null

signal dialogue_finished

const CHAR_DELAY: float = 0.045

@onready var panel: Panel = $Panel
@onready var text_label: RichTextLabel = $Panel/Margin/VBox/RichTextLabel
@onready var hint_label: Label = $Panel/Margin/VBox/HintLabel

func show_dialogue(key: String) -> void:
	var lines: Array = DialogueData.get_dialogue(key)
	if lines.is_empty():
		push_warning("대사 키를 찾을 수 없음: " + key)
		return
	_queue = lines
	_index = 0
	is_open = true
	panel.show()
	_show_line(_queue[_index])

func _show_line(text: String) -> void:
	text_label.text = text
	text_label.visible_characters = 0
	hint_label.hide()

	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(text_label, "visible_characters", text.length(),
						  text.length() * CHAR_DELAY)
	_tween.tween_callback(func() -> void: hint_label.show())

func _unhandled_input(event: InputEvent) -> void:
	if not is_open:
		return
	var pressed := false
	if event is InputEventScreenTouch and event.pressed:
		pressed = true
	elif event is InputEventMouseButton and event.pressed \
			and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
		pressed = true
	if pressed:
		get_viewport().set_input_as_handled()
		_advance()

func _advance() -> void:
	if text_label.visible_characters < text_label.text.length():
		if _tween:
			_tween.kill()
		text_label.visible_characters = -1
		hint_label.show()
		return

	_index += 1
	if _index < _queue.size():
		_show_line(_queue[_index])
	else:
		_close()

func _close() -> void:
	is_open = false
	panel.hide()
	emit_signal("dialogue_finished")
