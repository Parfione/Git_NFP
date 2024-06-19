shader_type canvas_item;

uniform float speed = 0.10;
uniform float opacity = 0.11;
uniform vec4 color : source_color = vec4(1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	//float opacity = COLOR.a;
	vec4 base_texture = texture(TEXTURE,UV+TIME*speed) * color;
	base_texture.a *= opacity;
	COLOR = base_texture;
	//COLOR.a = opacity;
}

