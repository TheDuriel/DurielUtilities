@tool
class_name Arranger3D
extends Node3D

const COLINEAR_FIX_OFFSET: Vector3 = Vector3(0.001, 0.001, 0.001)
const EDITOR_TICK_COOLDOWN: int = 2 # Only tick every x frame in the editor to save a bit of performance

enum MODE {NONE, LINE, GRID, GRID_HULL, RING, SPHERE}
enum AXIS {X, Y, Z}

# Can't be a constant cause I'm too lazy to make the functions static.
var _mode_functions: Dictionary[MODE, Callable] = {
		MODE.LINE : _generate_line,
		MODE.GRID : _generate_grid,
		MODE.GRID_HULL : _generate_grid_hull,
		MODE.RING : _generate_ring,
		MODE.SPHERE : _generate_sphere,
		}

@export_group("Buttons")
@export_tool_button("Randomize") var randomize_button: Callable = _randomize_children_order
@export_tool_button("Clear Rotations") var clear_rotations_button: Callable = _clear_rotations
@export_tool_button("Bake") var bake_button: Callable = _bake
@export_tool_button("Add Missing Nodes") var add_missing_button: Callable = _add_missing
@export_tool_button("Delete Extra Nodes") var delete_extra_button: Callable = _delete_extra
@export_tool_button("Fill with Marker3D") var fill_marker_button: Callable = _fill_marker
@export_tool_button("Delete Half") var delete_half_button: Callable = _delete_half
@export_tool_button("Debug") var debug_button: Callable = _debug

@export_group("Settings")
@export_custom( PROPERTY_HINT_NONE, "Number of child nodes.", PROPERTY_USAGE_READ_ONLY | PROPERTY_USAGE_DEFAULT)
var children: int:
	get: return _count
@export_custom( PROPERTY_HINT_NONE, "Required child nodes.", PROPERTY_USAGE_READ_ONLY | PROPERTY_USAGE_DEFAULT)
var required: int:
	get: return _required
@export var run_in_editor: bool = true
@export var run_in_game: bool = false
@export var lerp_position: bool = false
@export var lerp_speed_in_units: float = 1.0
@export var look_at_center: bool = false
@export var use_rotation_offset: bool = false
@export var rotation_offset: Vector3 = Vector3.ZERO


@export_group("Mode")
@export var mode: MODE = MODE.NONE:
	set(value):
		mode = value
		notify_property_list_changed()

@export_group("Line Settings")
@export var line_length: float = 16.0:
	set(value): line_length = max(value, 1.0)
@export var line_axis: AXIS = AXIS.X

@export_group("Grid Settings")
@export var grid_spacing: Vector3 = Vector3(2.0, 2.0, 2.0)
@export var grid_size: Vector3i = Vector3(4, 4, 4):
	set(value):
		value.x = max(value.x, 1)
		value.y = max(value.y, 1)
		value.z = max(value.z, 1)
		grid_size = value

@export_group("Ring Settings")
@export var ring_radius: float = 16.0:
	set(value): ring_radius = max(value, 1.0)

@export_group("Sphere Settings")
@export var sphere_scale: float = 1.0
@export var sphere_radius: float = 8.0
@export var sphere_height: float = 16.0
@export var sphere_segments: int = 16
@export var sphere_rings: int = 8
@export var sphere_is_hemispere: bool = false


@export_group("Grid Hull Settings")
@export var grid_hull_spacing: float = 2.0
@export var grid_hull_size: Vector3i = Vector3i(4, 4, 4):
	set(value):
		value.x = max(value.x, 2)
		value.y = max(value.y, 2)
		value.z = max(value.z, 2)
		grid_hull_size = value


var _editor_tick_count: int = 0
var _count: int = 0
var _required: int = 0
var _points: Array[Vector3] = []


func _validate_property(property: Dictionary) -> void:
	var pname: String = property.name
	
	var k: Array = MODE.keys()
	var valid: String = k[mode].to_lower()
	var invalid: Array = k
	invalid.erase(k[mode])
	
	if pname.begins_with(valid):
		return
	if pname in ["script", "editor_description"]:
		return
	
	for prefix: String in invalid:
		if pname.begins_with(prefix.to_lower()):
			property.usage = PROPERTY_USAGE_STORAGE


func _ready() -> void:
	child_entered_tree.connect(_on_child_entered)
	child_exiting_tree.connect(_on_child_exiting)


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if not run_in_editor:
			return
		if not self in EditorInterface.get_selection().get_selected_nodes():
			return
		
		_editor_tick_count += 1
		
		if _editor_tick_count < EDITOR_TICK_COOLDOWN:
			return
		_editor_tick_count = 0
		
	if not Engine.is_editor_hint() and not run_in_game:
		return
	
	_update()


func _update() -> void:
	_create_points()
	_move_nodes()


func _create_points() -> void:
	_count = get_child_count()
	_points = []
	_points.resize(_count)
	
	if _count < 1:
		return
	
	if mode == MODE.NONE:
		return
	
	if mode in _mode_functions:
		_mode_functions[mode].call()


func _move_nodes() -> void:
	for c: int in _count:
		var n: Node = get_child(c)
		
		if n is Node3D:
			
			if lerp_position:
				n.position = n.position.move_toward(_points[c], lerp_speed_in_units)
			else:
				n.position = _points[c]
			
			if look_at_center:
				if n.position.is_equal_approx(Vector3.ZERO):
					continue
				
				n.look_at(self.global_position, Vector3.UP + COLINEAR_FIX_OFFSET)
				if use_rotation_offset:
					n.rotation_degrees += rotation_offset
			
			elif use_rotation_offset:
				n.rotation_degrees = rotation_offset


func _randomize_children_order() -> void:
	for n: Node in get_children():
		move_child(n, randi_range(0, get_child_count(-1)))


func _clear_rotations() -> void:
	for n: Node in get_children():
		if n is Node3D:
			n.rotation = Vector3.ZERO


func _bake() -> void:
	if not Engine.is_editor_hint():
		return
	
	set_process(false)
	await get_tree().process_frame
	replace_by.call_deferred(Node3D.new())


func _add_missing() -> void:
	_update()
	
	if required == -1:
		return
	
	var missing: int = required - children
	
	var c: Node = get_child(0)
	
	if missing > 0:
		for i: int in missing:
			var n: Node = c.duplicate()
			add_child(n)
			n.owner = c.owner


func _delete_extra() -> void:
	_update()
	
	if required == -1:
		return
	
	if not children > required:
		return
	
	var cnodes: Array[Node] = get_children()
	var c: Array[Node] = cnodes.slice(required)
	for n: Node in c:
		n.queue_free()


func _fill_marker() -> void:
	_update()
	
	if required == -1:
		return
	
	var missing: int = required - children
	
	if missing > 0:
		for i: int in missing:
			var m: Marker3D = Marker3D.new()
			add_child(m)
			m.owner = owner if owner else self


func _delete_half() -> void:
	_update()
	
	var cnodes: Array[Node] = get_children()
	@warning_ignore("integer_division")
	var c: Array[Node] = cnodes.slice(cnodes.size() / 2)
	for n: Node in c:
		n.queue_free()


func _debug() -> void:
	pass


func _on_child_entered(_node: Node) -> void:
	_update.call_deferred()


func _on_child_exiting(_node: Node) -> void:
	_update.call_deferred()


func _generate_line() -> void:
	_required = -1
	
	for c: int in _count:
		var a: float = (line_length / _count) * c
		a -= line_length * 0.5
		match line_axis:
			AXIS.X: _points[c] = Vector3(a, 0.0, 0.0)
			AXIS.Y: _points[c] = Vector3(0.0, a, 0.0)
			AXIS.Z: _points[c] = Vector3(0.0, 0.0, a)


func _generate_grid() -> void:
	var max_grid_nodes: int = grid_size.x * grid_size.y * grid_size.z
	_required = max_grid_nodes
	
	var center_offset: Vector3 = ((Vector3(grid_size) - Vector3.ONE) / 2) * grid_spacing
	
	for c: int in _count:
		if c >= max_grid_nodes:
			return
		
		@warning_ignore("integer_division")
		@warning_ignore("integer_division")
		var p: Vector3 = Vector3(
				c % grid_size.x,
				c / (grid_size.x * grid_size.z),
				(c / grid_size.x) % grid_size.z
				)
		p *= grid_spacing
		p -= center_offset
		_points[c] = p


func _generate_grid_hull() -> void:
	var verts: Array[Vector3] = []
	
	var center_offset: Vector3 = ((Vector3(grid_hull_size) - Vector3.ONE) / 2) * grid_hull_spacing
	
	# Floor and Ceiling
	for x: int in grid_hull_size.x:
		for z: int in grid_hull_size.z:
			var v1: Vector3 = Vector3(x, 0.0, z) * grid_hull_spacing
			var v2: Vector3 = Vector3(x, grid_hull_size.y - 1, z) * grid_hull_spacing
			verts.append(v1 - center_offset)
			verts.append(v2 - center_offset)
	
	# Walls
	for y: int in range(1, grid_hull_size.y - 1):
		for x: int in grid_hull_size.x:
			for z: int in grid_hull_size.z:
				if not x in [0, grid_hull_size.x - 1] and not z in [0, grid_hull_size.z - 1]:
					continue
				
				var v: Vector3 = Vector3(x, y, z) * grid_hull_spacing
				verts.append(v - center_offset)
	
	_required = verts.size()
	
	for c: int in min(_count, verts.size()):
		_points[c] = verts[c]


func _generate_ring() -> void:
	_required = -1
	
	for c: int in _count:
		var r: float = (TAU / _count) * c
		_points[c] = Vector3.RIGHT.rotated(Vector3.UP, r) * ring_radius


func _generate_sphere() -> void:
	var primitive: SphereMesh = SphereMesh.new()
	primitive.height = sphere_height * sphere_scale
	primitive.radius = sphere_radius * sphere_scale
	primitive.radial_segments = sphere_segments
	primitive.rings = sphere_rings
	primitive.is_hemisphere = sphere_is_hemispere
	
	var a: Array = primitive.get_mesh_arrays()[0]
	var verts: Array[Vector3] = []
	@warning_ignore("integer_division")
	for i: int in range(0, a.size(), 2):
		verts.append(a[i])
	
	_required = verts.size()
	
	for c: int in min(_count, verts.size()):
		_points[c] = verts[c]
