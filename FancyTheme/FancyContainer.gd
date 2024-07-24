@tool
class_name FancyContainer
extends MarginContainer

const A_BOX_NAME: String = "a_box"
const A_BOX_MARGIN_NAMES: Array[String] = [
		"a_box_margin_left", "a_box_margin_up",
		"a_box_margin_right", "a_box_margin_down"]
const B_BOX_NAME: String = "b_box"
const B_BOX_MARGIN_NAMES: Array[String] = [
		"b_box_margin_left", "b_box_margin_up",
		"b_box_margin_right", "b_box_margin_down"]
const C_BOX_NAME: String = "c_box"
const C_BOX_MARGIN_NAMES: Array[String] = [
		"c_box_margin_left", "c_box_margin_up",
		"c_box_margin_right", "c_box_margin_down"]

var _a_box: StyleBox:
	get: return get_theme_stylebox(A_BOX_NAME)
var _b_box: StyleBox:
	get: return get_theme_stylebox(B_BOX_NAME)
var _c_box: StyleBox:
	get: return get_theme_stylebox(C_BOX_NAME)

var _a_box_margins: Array[int]:
	get:
		var a: Array[int] = [
			get_theme_constant(A_BOX_MARGIN_NAMES[0]), get_theme_constant(A_BOX_MARGIN_NAMES[1]),
			get_theme_constant(A_BOX_MARGIN_NAMES[2]), get_theme_constant(A_BOX_MARGIN_NAMES[3])]
		return a

var _b_box_margins: Array[int]:
	get:
		var b: Array[int] = [
			get_theme_constant(B_BOX_MARGIN_NAMES[0]), get_theme_constant(B_BOX_MARGIN_NAMES[1]),
			get_theme_constant(B_BOX_MARGIN_NAMES[2]), get_theme_constant(B_BOX_MARGIN_NAMES[3])]
		return b

var _c_box_margins: Array[int]:
	get:
		var c: Array[int] = [
			get_theme_constant(C_BOX_MARGIN_NAMES[0]), get_theme_constant(C_BOX_MARGIN_NAMES[1]),
			get_theme_constant(C_BOX_MARGIN_NAMES[2]), get_theme_constant(C_BOX_MARGIN_NAMES[3])]
		return c


func _draw() -> void:
	var a_box: StyleBox = _a_box
	if a_box:
		_draw_box(a_box, _a_box_margins)
	
	var b_box: StyleBox = _b_box
	if b_box:
		_draw_box(a_box, _b_box_margins)
	
	var c_box: StyleBox = _c_box
	if c_box:
		_draw_box(c_box, _c_box_margins)


func _draw_box(box: StyleBox, margins: Array[int]) -> void:
	var margin_topleft: Vector2 = Vector2(margins[0], margins[1])
	var margin_botright: Vector2 = Vector2(margins[0], margins[1])
	var rect: Rect2 = Rect2(
			Vector2.ZERO + margin_topleft,
			size - (margin_topleft + margin_botright))
	draw_style_box(box, rect)
