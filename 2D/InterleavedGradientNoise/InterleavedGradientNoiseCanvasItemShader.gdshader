shader_type canvas_item;
render_mode blend_mix;

// Color = Apply IGN to the color channel.
// This is best for gradient sprites without any alpha information
// Alpha = Apply IGN to the alpha channel.
// This is best for gradients that will be blended with the rest of the screen
// Both = Apply IGN to color and alpha channels.
// This should be idea in scenarios where an already color banded gradient is used.
// And it is then blended with the rest of the screen.

// Source: http://www.iryoku.com/next-generation-post-processing-in-call-of-duty-advanced-warfare (slide 122)
const vec3 IGN_MAGIC_NUMBERS = vec3(0.06711056, 0.00583715, 52.9829189);

uniform int mode : hint_enum("color", "alpha", "both") = 0;
uniform float intensity : hint_range(0.0, 1.0, 0.01) = 0.01;


float get_ign(vec2 pixel_pos) {
    return fract(IGN_MAGIC_NUMBERS.z * fract(dot(pixel_pos, IGN_MAGIC_NUMBERS.xy)));
}


vec3 apply_ign_color(vec3 color, vec2 screen_uv, vec2 screen_pixel_size) {
	return mix(color, vec3(get_ign(screen_uv / screen_pixel_size)), intensity);
}


float apply_ign_alpha(float alpha, vec2 screen_uv, vec2 screen_pixel_size) {
	return mix(alpha, get_ign(screen_uv / screen_pixel_size), intensity);
}

void fragment() {
	switch (mode) {
		case 0:
			COLOR.rgb = apply_ign_color(COLOR.rgb, SCREEN_UV, SCREEN_PIXEL_SIZE);
			break;
		case 1:
			COLOR.a = apply_ign_alpha(COLOR.a, SCREEN_UV, SCREEN_PIXEL_SIZE);
			break;
		case 2:
			COLOR.rgb = apply_ign_color(COLOR.rgb, SCREEN_UV, SCREEN_PIXEL_SIZE);
			COLOR.a = apply_ign_alpha(COLOR.a, SCREEN_UV, SCREEN_PIXEL_SIZE);
			break;
		default:
			COLOR = COLOR;
			break;
	}
}
