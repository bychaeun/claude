extends Node

## 조사 임계값: 이 수를 채우면 Phase 이벤트 발동
@export var investigate_threshold: int = 3

func _ready() -> void:
	add_to_group("phase_manager")

func on_investigate(_key: String) -> void:
	GameManager.investigate_count += 1
	if GameManager.investigate_count >= investigate_threshold:
		_trigger_event()

func _trigger_event() -> void:
	match GameManager.current_phase:
		0:
			# 관찰 → 눈 그림 추가 등장
			get_tree().call_group("eye_phase1", "show")
			AudioManager.play_sfx("footstep")
		1:
			# 왜곡 → 가구 이동 + TV 잡음
			get_tree().call_group("phase2_objects", "on_distort")
			AudioManager.play_sfx("tv_static")
		2:
			# 침식 → 그림자 추격 시작
			get_tree().call_group("shadow_trigger", "start_chase")
			AudioManager.play_sfx("heartbeat")
		3:
			pass
