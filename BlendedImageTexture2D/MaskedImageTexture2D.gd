@tool
class_name MaskedImageTexture2D
extends ImageTexture

@export var bake_now: bool:
	set(value):
		if value:
			bake()

@export var texture_base: Texture2D
@export var texture_blend: Texture2D

enum CHANNEL {RED, GREEN, BLUE, ALPHA}
@export var channel: CHANNEL = CHANNEL.RED

enum ALPHA_MODE {REPLACE, MIX}
@export var alpha_mode: ALPHA_MODE = ALPHA_MODE.REPLACE


func bake() -> void:
	var base_image: Image = texture_base.get_image()
	var base_size: Vector2i = base_image.get_size()
	var blend_image: Image = texture_blend.get_image()
	var blend_size: Vector2i = blend_image.get_size()
	
	if base_size != blend_size:
		blend_image.resize(base_size.x, base_size.y, Image.INTERPOLATE_BILINEAR)
	
	var image: Image = Image.create(
				base_size.x, base_size.y,
				base_image.has_mipmaps(), Image.FORMAT_RGBA8)
	
	for x: int in base_size.x:
		for y: int in base_size.y:
			
			var base_col: Color = base_image.get_pixel(x, y)
			var blend_col: Color = blend_image.get_pixel(x, y)
			
			var base_a: float = base_col.a
			var blend_a: float
			match channel:
				CHANNEL.RED:
					blend_a = blend_col.r
				CHANNEL.GREEN:
					blend_a = blend_col.g
				CHANNEL.BLUE:
					blend_a = blend_col.b
				CHANNEL.ALPHA:
					blend_a = blend_col.a
			
			var new_col: Color = base_col
			match alpha_mode:
				ALPHA_MODE.REPLACE:
					new_col.a = blend_a
				ALPHA_MODE.MIX:
					new_col.a = base_a if base_a < blend_a else blend_a
			
			image.set_pixel(x, y, new_col)
	
	set_image(image)
