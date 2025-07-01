class_name MenuGroup
extends Control

@export var _focus_target: Control:
	set(value): _focus_target = Glue.assert_value(value)
@export var _submenu_container: Container:
	set(value): _submenu_container = Glue.assert_value(value)
@export var _submenu_button_container: VBoxContainer:
	set(value): _submenu_button_container = Glue.assert_value(value)

@export_group("Button Style")
@export var _submenu_button_theme_type_variation: String
@export var _submenu_button_alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT

var _submenus: Array[SubMenu] = []
var _submenu_buttons: Array[Button] = []
var _button_group: ButtonGroup = ButtonGroup.new()
var _current_menu: SubMenu


func _ready() -> void:
	_find_submenus()


func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED:
		if not _focus_target.is_inside_tree():
			return
		if _focus_target.is_visible_in_tree():
			_focus_target.grab_click_focus()
			_focus_target.grab_focus()


func _find_submenus() -> void:
	for child: Node in _submenu_container.get_children():
		if child is SubMenu:
			_add_submenu(child)


func _add_submenu(sub_menu: SubMenu) -> void:
	_submenus.append(sub_menu)
	var b: Button = Button.new()
	b.name = sub_menu.menu_name
	b.text = sub_menu.menu_name
	b.alignment = _submenu_button_alignment
	b.theme_type_variation = _submenu_button_theme_type_variation
	b.button_group = _button_group
	b.toggle_mode = true
	b.pressed.connect(_on_submenu_button_pressed.bind(sub_menu), CONNECT_DEFERRED)
	_submenu_buttons.append(b)
	_submenu_button_container.add_child(b)


func _on_submenu_button_pressed(sm: SubMenu) -> void:
	_change_menu(sm)


func _change_menu(sm: SubMenu) -> void:
	if _current_menu == sm:
		return
	
	if _current_menu:
		_current_menu.open = false
		await _current_menu.closed_animated
	
	_current_menu = sm
	
	if _current_menu:
		_current_menu.open = true
