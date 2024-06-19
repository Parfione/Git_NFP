shader_type canvas_item;

uniform float speed = 0.005;
uniform vec4 color : source_color = vec4(1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	//float opacity = COLOR.a;
	vec4 base_texture = texture(TEXTURE,UV+TIME*speed*vec2(0.0,1.0)) * color;
	COLOR = base_texture;
	//COLOR.a = opacity;
}

