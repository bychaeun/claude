extends Node

var _music: AudioStreamPlayer
var _sfx: AudioStreamPlayer
var _streams: Dictionary = {}

func _ready() -> void:
	_music = AudioStreamPlayer.new()
	_music.volume_db = -6.0
	_music.bus = "Music"
	add_child(_music)

	_sfx = AudioStreamPlayer.new()
	_sfx.volume_db = 0.0
	_sfx.bus = "SFX"
	add_child(_sfx)

	_preload_sounds()

func _preload_sounds() -> void:
	var dir := "res://assets/audio/"
	var files := {
		"noise":     dir + "noise_ambient.ogg",
		"heartbeat": dir + "heartbeat.ogg",
		"footstep":  dir + "footstep.ogg",
		"tv_static": dir + "tv_static.ogg",
	}
	for key: String in files:
		if ResourceLoader.exists(files[key]):
			_streams[key] = load(files[key])

func play_music(name: String, loop: bool = true) -> void:
	if not _streams.has(name):
		return
	var stream: AudioStream = _streams[name]
	if stream is AudioStreamOggVorbis:
		(stream as AudioStreamOggVorbis).loop = loop
	_music.stream = stream
	_music.play()

func stop_music() -> void:
	_music.stop()

func play_sfx(name: String) -> void:
	if not _streams.has(name):
		return
	_sfx.stream = _streams[name]
	_sfx.play()
