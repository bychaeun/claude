shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture, filter_nearest, repeat_disable;

uniform float noise_amount      : hint_range(0.0, 0.3)  = 0.06;
uniform float scanline_strength : hint_range(0.0, 0.6)  = 0.15;
uniform float vignette_strength : hint_range(0.0, 1.0)  = 0.35;

float rand(vec2 seed) {
	return fract(sin(dot(seed, vec2(127.1, 311.7))) * 43758.5453123);
}

void fragment() {
	vec2 uv = SCREEN_UV;
	vec4 col = texture(screen_tex, uv);

	float scan = sin(uv.y * 3.14159265 * 320.0) * 0.5 + 0.5;
	col.rgb *= 1.0 - scanline_strength * (1.0 - scan);

	float grain = rand(uv + fract(TIME * 0.31 + vec2(0.17, 0.83)));
	col.rgb += (grain * 2.0 - 1.0) * noise_amount;

	vec2 vig = uv * (1.0 - uv);
	float v = clamp(pow(vig.x * vig.y * 16.0, vignette_strength * 2.0), 0.0, 1.0);
	col.rgb *= v;

	float luma = dot(col.rgb, vec3(0.299, 0.587, 0.114));
	col.rgb = mix(col.rgb, vec3(luma), 0.25);

	COLOR = col;
}
