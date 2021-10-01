shader_type canvas_item;

void fragment() {
	vec2 uv = UV;
	uv.x = mod(uv.x, 1.0);
	uv.y = mod(uv.y, 1.0);
	
	COLOR = texture(TEXTURE, uv);
}