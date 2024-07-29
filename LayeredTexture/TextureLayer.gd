@tool
class_name TextureLayer
extends Resource


@export var texture: Texture2D:
	set(value):
		texture = value
		emit_changed()

@export_category("Blend")
@export var blend_mode: BlendModes.MODE = BlendModes.MODE.NORMAL:
	set(value):
		blend_mode = value
		emit_changed()
@export_range(0.0, 1.0) var blend_value: float = 1.0:
	set(value):
		blend_value = value
		emit_changed()

@export_category("Mask")
@export var mask: Texture2D:
	set(value):
		mask = value
		emit_changed()

enum CHANNEL {RED, GREEN, BLUE, ALPHA}
@export var mask_channel: CHANNEL = CHANNEL.RED:
	set(value):
		mask_channel = value
		emit_changed()
enum MASK_MODE {REPLACE, MIX}
@export var mask_mode: MASK_MODE = MASK_MODE.REPLACE:
	set(value):
		mask_mode = value
		emit_changed()


func is_valid() -> bool:
	return true if texture else false
