shader_type canvas_item;

uniform float grayness = 0.5;
uniform float fade = 0.1;

void fragment(){
	COLOR = texture(TEXTURE, UV);
	float grayscale_power = length (COLOR.rgb) / length (vec3(1.));
	COLOR.rgb = COLOR.rgb * (1. - grayness) + vec3(grayscale_power) * grayness;
	COLOR.rgb = COLOR.rgb * (1. - fade) + fade / 2.;
}