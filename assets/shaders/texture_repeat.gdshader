shader_type spatial;

uniform sampler2D main_texture;

varying vec3 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	vec2 uv = world_pos.xz - floor(world_pos).xz;
	vec3 albedo = texture(main_texture, uv).rgb;
	ALBEDO = albedo;
}
