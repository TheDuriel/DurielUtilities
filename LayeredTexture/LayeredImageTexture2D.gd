@tool
class_name LayeredImageTexture2D
extends ImageTexture

@export_group("Export")
@export_tool_button("Save .png") var save_png_button: Callable = save_png
@export_tool_button("Bake") var bake_button: Callable = _bake

@export_group("Settings")
@export var size: Vector2i = Vector2i(100, 100):
	set(value):
		size = value
		_bake()

enum BASE_MODE {COLOR, TEXTURE}
@export var base_mode: BASE_MODE = BASE_MODE.COLOR:
	set(value):
		base_mode = value
		_bake()

@export var base_color: Color = Color.HOT_PINK:
	set(value):
		base_color = value
		_bake()
@export var base_texture: Texture2D:
	set(value):
		base_texture = value
		_bake()

@export_group("Layers")
@export var layers: Array[TextureLayer] = []:
	set(value):
		for layer: TextureLayer in layers:
			if layer:
				layer.changed.disconnect(_on_layer_changed)
		layers = value
		for layer: TextureLayer in layers:
			if layer:
				layer.changed.connect(_on_layer_changed)
		_bake()


func _init() -> void:
	if not Engine.is_editor_hint():
		# Avoid baking at runtime, under the assumption that we have baked in the editor.
		# This is a very naive check, but should avoid most error cases.
		if get_height() == size.y:
			return
	
	_bake()


func _on_layer_changed() -> void:
	_bake()


func _bake() -> void:
	
	var image: Image
	
	match base_mode:
		
		BASE_MODE.COLOR:
			image = Image.create(size.x, size.y, true, Image.FORMAT_RGBA8)
		
		BASE_MODE.TEXTURE:
			if not base_texture:
				return
			
			image = base_texture.get_image()
			if image.is_compressed():
				var error: int = image.decompress()
				if not error == OK:
					Logger.warn(self, _bake, "Could not decompress base texture. Failed bake.")
					return
			
			image.resize(size.x, size.y)
	
	for layer: TextureLayer in layers:
		if not layer:
			continue
		if not layer.is_valid():
			continue
		
		image = _blend_layer(image, layer)
	
	set_image(image)
	emit_changed()


func _blend_layer(image: Image, layer: TextureLayer) -> Image:
	
	var base_image: Image = image
	var base_size: Vector2i = base_image.get_size()
	var blend_image: Image = _get_layer_image(layer)
	if not blend_image:
		return base_image
	var blend_size: Vector2i = blend_image.get_size()
	
	if base_size != blend_size:
		var error: int = OK
		if blend_image.is_compressed():
			error = blend_image.decompress()
		
		if error == OK:
			blend_image.resize(base_size.x, base_size.y, Image.INTERPOLATE_BILINEAR)
		else:
			Logger.warn(self, _blend_layer, "Could not resize compressed blend. Skipping.")
	
	image = Image.create(
				base_size.x, base_size.y,
				base_image.has_mipmaps(), Image.FORMAT_RGBA8)
	
	var operation: Callable = BlendModes.get_operation(layer.blend_mode)
	
	for x: int in base_size.x:
		for y: int in base_size.y:
			
			var base_col: Color = base_image.get_pixel(x, y)
			var blend_col: Color = blend_image.get_pixel(x, y)
			var new_col: Color = operation.call(base_col, blend_col, layer.blend_value)
			
			image.set_pixel(x, y, new_col)
	
	return image


func _get_layer_image(layer: TextureLayer) -> Image:
	if not layer.texture:
		Logger.warn(self, _get_layer_image, "No texture set in layer.")
		return null
	
	var base_image: Image = layer.texture.get_image()
	var base_size: Vector2i = base_image.get_size()
	
	if not layer.mask:
		return base_image
	
	var mask_image: Image = layer.mask.get_image()
	var mask_size: Vector2i = mask_image.get_size()
	
	if base_size != mask_size:
		var error: int = OK
		if base_image.is_compressed():
			error = base_image.decompress()
		
		if error == OK:
			mask_image.resize(base_size.x, base_size.y, Image.INTERPOLATE_BILINEAR)
		else:
			Logger.warn(self, _get_layer_image, "Could not resize compressed mask. Skipping.")
	
	var image: Image = Image.create(
				base_size.x, base_size.y,
				base_image.has_mipmaps(), Image.FORMAT_RGBA8)
	
	for x: int in base_size.x:
		for y: int in base_size.y:
			
			var base_col: Color = base_image.get_pixel(x, y)
			var mask_col: Color = mask_image.get_pixel(x, y)
			
			var base_a: float = base_col.a
			var mask_a: float
			match layer.mask_channel:
				TextureLayer.CHANNEL.RED:
					mask_a = mask_col.r
				TextureLayer.CHANNEL.GREEN:
					mask_a = mask_col.g
				TextureLayer.CHANNEL.BLUE:
					mask_a = mask_col.b
				TextureLayer.CHANNEL.ALPHA:
					mask_a = mask_col.a
			
			var new_col: Color = base_col
			match layer.mask_mode:
				TextureLayer.MASK_MODE.REPLACE:
					new_col.a = mask_a
				TextureLayer.MASK_MODE.MIX:
					new_col.a = base_a if base_a < mask_a else mask_a
			
			image.set_pixel(x, y, new_col)
	
	return image


func save_png() -> void:
	_bake()
	
	var target_path: String = resource_path
	
	if not target_path:
		print("LayeredImageTexture must first be saved as .tres or .res.")
		return
	
	if target_path.ends_with(".tres"):
		target_path = target_path.replace(".tres", ".png")
	if target_path.ends_with(".res"):
		target_path = target_path.replace(".res", ".png")
	print("Trying to save LayeredImageTexture as baked .png to %s" % target_path)
	
	var error: int = get_image().save_png(target_path)
	if not error == OK:
		print("Saving failed with error %" % error)
	else:
		print("Done, please tab out of the editor to reload the File Dock. >.<")
