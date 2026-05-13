extends Node

var _data: Dictionary = {}

func _ready() -> void:
	_load()

func _load() -> void:
	var file := FileAccess.open("res://data/dialogues.json", FileAccess.READ)
	if file == null:
		push_error("dialogues.json을 열 수 없습니다.")
		return
	var txt := file.get_as_text()
	file.close()
	var json := JSON.new()
	if json.parse(txt) == OK:
		_data = json.get_data()
	else:
		push_error("dialogues.json 파싱 실패: " + json.get_error_message())

func get_dialogue(key: String) -> Array:
	return _data.get(key, [])
