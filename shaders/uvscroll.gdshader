shader_type canvas_item;

global uniform float time_scale;

void fragment() {
	vec2 moving_uv = vec2(UV.x - TIME / time_scale, UV.y);
	vec4 in_tex = texture(TEXTURE, moving_uv);
	COLOR = in_tex;
}
