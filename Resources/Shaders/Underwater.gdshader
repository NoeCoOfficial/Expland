shader_type canvas_item;

// To adjust wave size play with the frequency
// property in the fast_noise variable.

uniform vec4 color : source_color;

uniform sampler2D fast_noise : repeat_enable;
uniform sampler2D screen_content : hint_screen_texture;

uniform vec2 speed = vec2(0.03, 0.07);

uniform float time_multiplier = 1.0;

uniform float color_influence_x = 1.0;
uniform float color_influence_y = 1.0;
uniform float color_influence_gb = 1.0;
uniform float wave_strength = 2.0;

void fragment() {
	vec2 uv = UV + speed * TIME * time_multiplier;
	vec2 noise = texture(fast_noise, uv).rg;

	COLOR = vec4(color.r, color.g, color.b, 1) + vec4(color_influence_x, color_influence_y, color_influence_gb, 1.0);
	COLOR *= texture(screen_content, SCREEN_UV + noise * wave_strength / 100.0);
}
