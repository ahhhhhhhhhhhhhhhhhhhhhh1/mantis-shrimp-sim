shader_type canvas_item;

uniform float a : hint_range(-1.0, 1.0) = 0.0;


void fragment() {
	COLOR = ((abs(vec4(UV.x, UV.y, sin(TIME * 5.0), a)) + (sin(TIME * 1.0) / 5.0)) * vec4(0.8, 0.8, 0.8, 1)) + vec4(0.2, 0.2, 0.2, 0);
	
}
