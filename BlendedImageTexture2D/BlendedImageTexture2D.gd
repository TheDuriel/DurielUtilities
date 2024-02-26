@tool
class_name BlendedImageTexture2D
extends ImageTexture

@export var bake_now: bool:
	set(value):
		if value:
			bake()

@export var texture_base: Texture2D:
	set(value):
		if value is CompressedTexture2D:
			return
		texture_base = value
		_needs_baking = true
@export var texture_blend: Texture2D:
	set(value):
		if value is CompressedTexture2D:
			return
		texture_blend = value
		_needs_baking = true

enum BLEND_MODE {
		NORMAL, #DISSOLVE,
		DARKEN, MULTIPLY, COLOR_BURN, LINEAR_BURN, #DARKER_COLOR,
		LIGHTEN, SCREEN, COLOR_DODGE, LINEAR_DODGE, #LIGHTER_COLOR,
		OVERLAY, SOFT_LIGHT, HARD_LIGHT, VIVID_LIGHT, LINEAR_LIGHT,
		PIN_LIGHT, HARD_MIX, DIFFERENCE, EXCLUSION, SUBTRACT, #DIVIDE,
		#HUE, SATURATION, COLOR, LUMINOSITY
		}
@export var blend_mode: BLEND_MODE = BLEND_MODE.NORMAL:
	set(value):
		blend_mode = value
		_needs_baking = true

@export_range(0.0, 1.0) var opacity: float = 1.0:
	set(value):
		opacity = value
		_needs_baking = true
enum ALPHA_MODE {KEEP_BASE, KEEP_BLEND, DISCARD}
@export var alpha_mode: ALPHA_MODE = ALPHA_MODE.KEEP_BASE:
	set(value):
		alpha_mode = value
		_needs_baking = true

var _needs_baking: bool = false


func bake() -> void:
	if texture_base is BlendedImageTexture2D or texture_base is MaskedImageTexture2D:
		texture_base.bake()
	if texture_blend is BlendedImageTexture2D or texture_blend is MaskedImageTexture2D:
		texture_blend.bake()
	
	if not _needs_baking:
		return
	_needs_baking = false
	
	var operation: Callable
	
	match blend_mode:
		BLEND_MODE.NORMAL: operation = BlendModes.normal
		BLEND_MODE.DARKEN: operation = BlendModes.darken
		BLEND_MODE.MULTIPLY: operation = BlendModes.multiply
		BLEND_MODE.COLOR_BURN: operation = BlendModes.color_burn
		BLEND_MODE.LINEAR_BURN: operation = BlendModes.linear_burn
		BLEND_MODE.SCREEN: operation = BlendModes.screen
		BLEND_MODE.COLOR_DODGE: operation = BlendModes.color_dodge
		BLEND_MODE.LINEAR_DODGE: operation = BlendModes.linear_dodge
		BLEND_MODE.OVERLAY: operation = BlendModes.overlay
		BLEND_MODE.SOFT_LIGHT: operation = BlendModes.soft_light
		BLEND_MODE.HARD_LIGHT: operation = BlendModes.hard_light
		BLEND_MODE.VIVID_LIGHT: operation = BlendModes.vivid_light
		BLEND_MODE.LINEAR_LIGHT: operation = BlendModes.linear_light
		BLEND_MODE.PIN_LIGHT: operation = BlendModes.pin_light
		BLEND_MODE.HARD_MIX: operation = BlendModes.hard_mix
		BLEND_MODE.DIFFERENCE: operation = BlendModes.difference
		BLEND_MODE.EXCLUSION: operation = BlendModes.exclusion
		BLEND_MODE.SUBTRACT: operation = BlendModes.subract
	
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
			var new_col: Color = operation.call(base_col, blend_col, opacity)
			
			match alpha_mode:
				ALPHA_MODE.KEEP_BASE:
					new_col.a = base_col.a
				ALPHA_MODE.KEEP_BLEND:
					new_col.a = blend_col.a
				ALPHA_MODE.DISCARD:
					new_col.a = 1.0
			
			image.set_pixel(x, y, new_col)
	
	set_image(image)
	emit_changed()
