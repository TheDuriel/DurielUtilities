class_name BlendModes
extends RefCounted

# Commented out ones are not implemented.
enum MODE {
		NORMAL, #DISSOLVE,
		DARKEN, MULTIPLY, COLOR_BURN, LINEAR_BURN, #DARKER_COLOR,
		LIGHTEN, SCREEN, COLOR_DODGE, LINEAR_DODGE, #LIGHTER_COLOR,
		OVERLAY, SOFT_LIGHT, HARD_LIGHT, VIVID_LIGHT, LINEAR_LIGHT,
		PIN_LIGHT, HARD_MIX, DIFFERENCE, EXCLUSION, SUBTRACT, #DIVIDE,
		#HUE, SATURATION, COLOR, LUMINOSITY
		}


static func get_operation(mode: MODE) -> Callable:
	match mode:
		MODE.NORMAL: return normal
		MODE.DARKEN: return darken
		MODE.MULTIPLY: return multiply
		MODE.COLOR_BURN: return color_burn
		MODE.LINEAR_BURN: return linear_burn
		MODE.SCREEN: return screen
		MODE.COLOR_DODGE: return color_dodge
		MODE.LINEAR_DODGE: return linear_dodge
		MODE.OVERLAY: return overlay
		MODE.SOFT_LIGHT: return soft_light
		MODE.HARD_LIGHT: return hard_light
		MODE.VIVID_LIGHT: return vivid_light
		MODE.LINEAR_LIGHT: return linear_light
		MODE.PIN_LIGHT: return pin_light
		MODE.HARD_MIX: return hard_mix
		MODE.DIFFERENCE: return difference
		MODE.EXCLUSION: return exclusion
		MODE.SUBTRACT: return subract
	return normal


static func normal(base: Color, blend: Color, opacity: float) -> Color:
	return _normal_v3v3(base, blend) * opacity + base * (1.0 - opacity)


static func _normal_v3v3(_base: Color, blend: Color) -> Color:
	return blend


static func darken(base: Color, blend: Color, opacity: float) -> Color:
	return _darken_v3v3(base, blend) * opacity + base * (1.0 - opacity)


static func _darken_v3v3(base: Color, blend: Color) -> Color:
	return Color(_darken_ff(base.r, blend.r), _darken_ff(base.g, blend.g), _darken_ff(base.b, blend.b))


static func _darken_ff(base: float, blend: float) -> float:
	return min(base, blend)


static func multiply(base: Color, blend: Color, opacity: float) -> Color:
	return _multiply_v3v3(base, blend) * opacity + base * (1.0 - opacity)


static func _multiply_v3v3(base: Color, blend: Color) -> Color:
	return base * blend


static func color_burn(base: Color, blend: Color, opacity: float) -> Color:
	return _color_burn_v3v3(base, blend) * opacity + base * (1.0 - opacity)


static func _color_burn_v3v3(base: Color, blend: Color) -> Color:
	return Color(_color_burn_ff(base.r, blend.r), _color_burn_ff(base.g, blend.g), _color_burn_ff(base.b, blend.b))


static func _color_burn_ff(base: float, blend: float) -> float:
	return blend if is_equal_approx(blend, 0.0) else max((1.0 - ((1.0 - base) / blend)),0.0)


static func linear_burn(base: Color, blend: Color, opacity: float) -> Color:
	return _linear_burn_v3v3(base, blend) * opacity + base * (1.0 - opacity)


static func _linear_burn_v3v3(base: Color, blend: Color) -> Color:
	return Color(_linear_burn_ff(base.r, blend.r), _linear_burn_ff(base.g, blend.g), _linear_burn_ff(base.b, blend.b))


static func _linear_burn_ff(base: float, blend: float) -> float:
	return max(base + blend - 1.0, 0.0)


static func lighten(base: Color, blend: Color, opacity: float) -> Color:
	return _lighten_v3v3(base, blend) * opacity + base * (1.0 - opacity)


static func _lighten_v3v3(base: Color, blend: Color) -> Color:
	return Color(_lighten_ff(base.r, blend.r), _lighten_ff(base.g, blend.g), _lighten_ff(base.b, blend.b))


static func _lighten_ff(base: float, blend: float) -> float:
	return max(base, blend)


static func screen(base: Color, blend: Color, opacity: float) -> Color:
	return _screen_v3v3(base, blend) * opacity + base * (1.0 - opacity)


static func _screen_v3v3(base: Color, blend: Color) -> Color:
	return Color(_screen_ff(base.r, blend.r), _screen_ff(base.g, blend.g), _screen_ff(base.b, blend.b))


static func _screen_ff(base: float, blend: float) -> float:
	return 1.0 - ((1.0 - base) * (1.0 - blend))


static func color_dodge(base: Color, blend: Color, opacity: float) -> Color:
	return _color_dodge_v3v3(base, blend) * opacity + base * (1.0 - opacity)


static func _color_dodge_v3v3(base: Color, blend: Color) -> Color:
	return Color(_color_dodge_ff(base.r, blend.r), _color_dodge_ff(base.g, blend.g), _color_dodge_ff(base.b, blend.b))


static func _color_dodge_ff(base: float, blend: float) -> float:
	return blend if is_equal_approx(blend, 1.0) else min(base / (1.0 - blend), 1.0)


static func linear_dodge(base: Color, blend: Color, opacity: float) -> Color:
	return _linear_dodge_v3v3(base, blend) * opacity + base * (1.0 - opacity)


static func _linear_dodge_v3v3(base: Color, blend: Color) -> Color:
	return Color(_linear_dodge_ff(base.r, blend.r), _linear_dodge_ff(base.g, blend.g), _linear_dodge_ff(base.b, blend.b))


static func _linear_dodge_ff(base: float, blend: float) -> float:
	return min(base + blend, 1.0)


static func overlay(base: Color, blend: Color, opacity: float) -> Color:
	return _overlay_v3v3(base, blend) * opacity + base * (1.0 - opacity)


static func _overlay_v3v3(base: Color, blend: Color) -> Color:
	return Color(_overlay_ff(base.r, blend.r), _overlay_ff(base.g, blend.g), _overlay_ff(base.b, blend.b))


static func _overlay_ff(base: float, blend: float) -> float:
	return 2.0 * base * blend if base < 0.5 else 1.0 - 2.0 * (1.0 - base) * (1.0 - blend)


static func soft_light(base: Color, blend: Color, opacity: float) -> Color:
	return _soft_light_v3v3(base, blend) * opacity + base * (1.0 - opacity)


static func _soft_light_v3v3(base: Color, blend: Color) -> Color:
	return Color(_soft_light_ff(base.r, blend.r), _soft_light_ff(base.g, blend.g), _soft_light_ff(base.b, blend.b))


static func _soft_light_ff(base: float, blend: float) -> float:
	return 2.0 * base * blend + base * base * (1.0 - 2.0 * blend) if blend < 0.5 else sqrt(base) * (2.0 * blend - 1.0) + 2.0 * base * (1.0 - blend)


static func hard_light(base: Color, blend: Color, opacity: float) -> Color:
	return _hard_light_v3v3(base, blend) * opacity + base * (1.0 - opacity)


static func _hard_light_v3v3(base: Color, blend: Color) -> Color:
	return _overlay_v3v3(blend, base)


static func vivid_light(base: Color, blend: Color, opacity: float) -> Color:
	return _vivid_light_v3v3(base, blend) * opacity + base * (1.0 - opacity)


static func _vivid_light_v3v3(base: Color, blend: Color) -> Color:
	return Color(_vivid_light_ff(base.r, blend.r), _vivid_light_ff(base.g, blend.g), _vivid_light_ff(base.b, blend.b))


static func _vivid_light_ff(base: float, blend: float) -> float:
	return _color_burn_ff(base, 2.0 * blend) if blend < 0.5 else _color_dodge_ff(base, 2.0 * (blend - 0.5))


static func linear_light(base: Color, blend: Color, opacity: float) -> Color:
	return _linear_light_v3v3(base, blend) * opacity + base * (1.0 - opacity)


static func _linear_light_v3v3(base: Color, blend: Color) -> Color:
	return Color(_linear_light_ff(base.r, blend.r), _linear_light_ff(base.g, blend.g), _linear_light_ff(base.b, blend.b))


static func _linear_light_ff(base: float, blend: float) -> float:
	return _linear_burn_ff(base, 2.0 * blend) if blend < 0.5 else _linear_dodge_ff(base, 2.0 * (blend - 0.5))


static func pin_light(base: Color, blend: Color, opacity: float) -> Color:
	return _pin_light_v3v3(base, blend) * opacity + base * (1.0 - opacity)


static func _pin_light_v3v3(base: Color, blend: Color) -> Color:
	return Color(_pin_light_ff(base.r, blend.r), _pin_light_ff(base.g, blend.g), _pin_light_ff(base.b, blend.b))


static func _pin_light_ff(base: float, blend: float) -> float:
	return _darken_ff(base, 2.0 * blend) if blend < 0.5 else _lighten_ff(base, 2.0 * (blend - 0.5))


static func hard_mix(base: Color, blend: Color, opacity: float) -> Color:
	return _hard_mix_v3v3(base, blend) * opacity + base * (1.0 - opacity)


static func _hard_mix_v3v3(base: Color, blend: Color) -> Color:
	return Color(_hard_mix_ff(base.r, blend.r), _hard_mix_ff(base.g, blend.g), _hard_mix_ff(base.b, blend.b))


static func _hard_mix_ff(base: float, blend: float) -> float:
	return 0.0 if _vivid_light_ff(base, blend) < 0.5 else 1.0


static func difference(base: Color, blend: Color, opacity: float) -> Color:
	return _difference_v3v3(base, blend) * opacity + base * (1.0 - opacity)


static func _difference_v3v3(base: Color, blend: Color) -> Color:
	return Color(abs(base.r - blend.r), abs(base.g - blend.g), abs(base.b - blend.b))


static func exclusion(base: Color, blend: Color, opacity: float) -> Color:
	return _exclusion_v3v3(base, blend) * opacity + base * (1.0 - opacity)


static func _exclusion_v3v3(base: Color, blend: Color) -> Color:
	return base + blend - 2.0 * base * blend


static func subract(base: Color, blend: Color, opacity: float) -> Color:
	return _subract_v3v3(base, blend) * opacity + base * (1.0 - opacity)


static func _subract_v3v3(base: Color, blend: Color) -> Color:
	return Color(_subract_ff(base.r, blend.r), _subract_ff(base.g, blend.g), _subract_ff(base.b, blend.b))


static func _subract_ff(base: float, blend: float) -> float:
	return max(base + blend - 1.0, 0.0);
