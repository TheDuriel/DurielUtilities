class_name Glue
extends RefCounted
# A library of Setter/Getter function helpers
# Most of these allow for the connection of signals to functionsd
# Or implement data binding patterns

#region Readonly Glue

# Example use:
#var foo: Bar: # ReadOnly Property
	#set(value): Glue.readonly()
	#get: return _foo
#var _foo: Bar # Field

static func readonly() -> void:
	assert(false, "Tried to assign to ReadOnly property. Use the provided setter, if any.")


#region Validation Glue

# Example use:
#@export var foo: Control = value:
	#set(value): foo = Glue.assert_value(value)

static func assert_value(value: Variant) -> Variant:
	assert(not value == null, "Tried to assign Null to property that must not be null.")
	return value


#region Var Setter Glue

# Example use:
#var foo: Type = value:
	#set(value): foo = Glue.var_changed(value, changed_signal)


static func var_changed(value: Variant, changed_signal: Signal) -> Variant:
	changed_signal.emit(value)
	return value


#region Float Setter Glue

# Example use:
#var foo: float = 0.0:
	#set(value): foo = Glue.float_clamped(value, min, max, changed_signal)


static func float_changed(value: float, changed_signal: Signal) -> float:
	changed_signal.emit(value)
	return value


static func float_clamped(value: float, min_value: float, max_value: float, changed_signal: Signal) -> float:
	var r: float = clamp(value, min_value, max_value)
	changed_signal.emit(r)
	return r


#region Integer Setter Glue

# Example use:
#var foo: int = 0:
	#set(value): foo = Glue.int_clamped(value, min, max, changed_signal)


static func int_changed(value: int, changed_signal: Signal) -> int:
	changed_signal.emit(value)
	return value


static func int_clamped(value: int, min_value: int, max_value: int, changed_signal: Signal) -> int:
	var r: int = clampi(value, min_value, max_value)
	changed_signal.emit(r)
	return r


#region Signal Helper

# Simple helper for completely dissconnecting a signal
# Without the need to know if it had any connections to begin with

static func disconnect_all(a_signal: Signal) -> void:
	var c: Array[Dictionary] = a_signal.get_connections()
	for entry: Dictionary in c:
		var target: Callable = entry.callable
		a_signal.disconnect(target)


#region Control Node Signal Glue

# Example use:
#@export var my_button: Button:
	#set(value): my_button = Glue.glue_pressed(my_button, value, _on_button_pressed)


static func connect_signal(old: Signal, new: Signal, target_func: Callable) -> void:
	if old and old.is_connected(target_func):
		old.disconnect(target_func)
	if new:
		new.connect(target_func)


static func connect_pressed(old: Button, new: Button, target_func: Callable) -> Button:
	connect_signal(old.pressed, new.pressed, target_func)
	return new


static func connect_focus_entered(old: Control, new: Control, target_func: Callable) -> Control:
	connect_signal(old.focus_entered, new.focus_entered, target_func)
	return new


static func connect_focus_exited(old: Control, new: Control, target_func: Callable) -> Control:
	connect_signal(old.focus_exited, new.focus_exited, target_func)
	return new


static func connect_mouse_entered(old: Control, new: Control, target_func: Callable) -> Control:
	connect_signal(old.mouse_entered, new.mouse_entered, target_func)
	return new


static func connect_mouse_exited(old: Control, new: Control, target_func: Callable) -> Control:
	connect_signal(old.mouse_exited, new.mouse_exited, target_func)
	return new


#region Data Binding Glue
# Connects a signal to a property. Classic data binding stuff.

# Example Use:
#func _ready() -> void:
	#Glue.bind_property(target_object, text_signal)


static func bind_property(property: String, target: Object, data_signal: Signal) -> void:
	assert(property in target, "Named property does not exist in target.")
	
	var connection_id: String = "%s_%s_%s" % [property, data_signal.get_object_id(), data_signal.get_name()]
	
	# Already Connected
	if target.has_meta(connection_id):
		return
	
	var target_func: Callable = _bind.bind(property, target)
	data_signal.connect(target_func)
	target.set_meta(connection_id, target_func)


static func unbind_property(property: String, target: Object, data_signal: Signal) -> void:
	assert(property in target, "Named property does not exist in target.")
	
	var connection_id: String = "%s_%s_%s" % [property, data_signal.get_object_id(), data_signal.get_name()]
	
	# Not connected
	if not target.has_meta(connection_id):
		return
	
	var target_func: Callable = target.get_meta(connection_id)
	data_signal.disconnect(target_func)
	
	target.remove_meta(connection_id)


static func _bind(property: String, target: Object, new_text: String) -> void:
	target[property] = new_text


#region Easy Initialization Glue
# Adds a child node, and returns it on the same line.

# Example use
#var foo: Bar = Glue.init_add_child(Bar.new(), self)

static func init_add_child(node: Node, owner: Node, child_name: String = "") -> Node:
	owner.add_child(node)
	if child_name:
		node.name = child_name
	return node
