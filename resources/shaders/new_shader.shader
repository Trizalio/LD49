shader_type canvas_item;

uniform vec4 color: hint_color = vec4(1.);

void fragment(){
	COLOR = texture(TEXTURE, UV);
	COLOR.rgb = color.rgb;
}