extends ColorRect

@export var noise_amount: float = 0.06
@export var scanline_strength: float = 0.15
@export var vignette_strength: float = 0.35

var _mat: ShaderMaterial

func _ready() -> void:
	_mat = material as ShaderMaterial
	if _mat == null:
		push_warning("CRTEffect: ShaderMaterial이 없습니다.")
		return
	_apply()

func _apply() -> void:
	_mat.set_shader_parameter("noise_amount", noise_amount)
	_mat.set_shader_parameter("scanline_strength", scanline_strength)
	_mat.set_shader_parameter("vignette_strength", vignette_strength)

func set_intensity(t: float) -> void:
	noise_amount = lerp(0.04, 0.18, t)
	scanline_strength = lerp(0.10, 0.35, t)
	vignette_strength = lerp(0.25, 0.6, t)
	if _mat:
		_apply()
