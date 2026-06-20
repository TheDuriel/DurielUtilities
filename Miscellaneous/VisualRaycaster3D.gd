class_name VisualRaycaster3D
extends Node3D

var simple_default_mask: int = 0
var simple_default_exclude: Array[RID] = []
var simple_default_do_bodies: bool = true
var simple_default_do_areas: bool = false

var material: Material = RayLineVisualizationMaterial.new()

var _state: PhysicsDirectSpaceState3D



# This is a significant performance optimization.
func _physics_process(_delta: float) -> void:
	_state = get_world_3d().direct_space_state


func cast_ray_simple(from: Vector3, to: Vector3, display_trail: bool = false) -> Dictionary:
	var p: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	p.from = from
	p.to = to
	p.collision_mask = simple_default_mask
	p.exclude = simple_default_exclude
	p.collide_with_bodies = simple_default_do_bodies
	p.collide_with_areas = simple_default_do_areas
	return cast_ray(p, display_trail)


func cast_ray(parameters: PhysicsRayQueryParameters3D, display_trail: bool = false) -> Dictionary:
	var r: Dictionary = _state.intersect_ray(parameters)
	if display_trail and r.is_empty():
		add_child(RayLineVisualization.new(material, parameters.from, parameters.to, false))
	elif display_trail and r:
		add_child(RayLineVisualization.new(material, parameters.from, r.position, true))
	return r


class RayLineVisualization extends MeshInstance3D:
	
	var _t: float = 0.0
	var _im: ImmediateMesh = ImmediateMesh.new()
	var _from: Vector3
	var _to: Vector3
	var _colliding: bool
	
	func _init(mat: Material, from: Vector3, to: Vector3, colliding: bool = false) -> void:
		material_override = mat
		mesh = _im
		cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		_from = from
		_to = to
		_colliding = colliding
	
	
	func _ready() -> void:
		global_position = _from
		_im.surface_begin(Mesh.PRIMITIVE_LINES)
		_im.surface_add_vertex(Vector3.ZERO)
		_im.surface_add_vertex(_to)
		_im.surface_set_color(Color.GREEN if _colliding else Color.RED)
		_im.surface_end()
	
	
	func _process(delta: float) -> void:
		_t += delta
		if _t >= 1.0:
			queue_free()


class RayLineVisualizationMaterial extends StandardMaterial3D:
	
	func _init() -> void:
		vertex_color_use_as_albedo = true
		shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
