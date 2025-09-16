class_name FancyTheme
extends Theme

# How to use this:
# Add the Name of a control to material_associations as a String Key
# This should be its Class name if it is a built in control.
# OR it's FileName if it is a custom class.
# (and that should be identical to its class name anyways.)
# This is the same name you would use in the Theme editor
# Then add a Material value to the Key (select Object, then drag the material in)

@export_category("Fancy Theme")
@export var enable_materials: bool = true
@export var override_existing_materials: bool = false
@export var material_associations: Dictionary = {} # Control Type : Material


func _init() -> void:
	if Engine.is_editor_hint():
		return
	if not enable_materials:
		return
	# Must be delayed otherwise MainLoop is null.
	_post_init.call_deferred()


func _post_init() -> void:
	if not enable_materials:
		return
	# Subscribe to the adding of ANY node to the tree.
	var main_loop: MainLoop = Engine.get_main_loop()
	if main_loop is SceneTree:
		_recursively_set_the_materials(main_loop)
		main_loop.node_added.connect(_on_node_added)


func _on_node_added(node: Node) -> void:
	if not enable_materials:
		return
	_apply_material(node)


func _recursively_set_the_materials(scene_tree: SceneTree) -> void:
	if not enable_materials:
		return
	var todo: Array[Node] = [scene_tree.root]
	while not todo.is_empty():
		var node: Node = todo.pop_front()
		todo.append_array(node.get_children())
		_apply_material(node)


func _apply_material(node: Node) -> void:
	if not node is Control:
		return
	
	if not override_existing_materials and node.material:
		return
	
	var c: Control = node as Control
	var target_material: Material
	
	# This only works if get_class is defined or it is a built in node.
	var node_class: String = c.get_class()
	if node_class in material_associations:
		target_material = material_associations[node_class]
	# This only works if the node has a script, returns get_class() otherwise.
	var node_file_name: String = DurielLogger.get_object_file_name(c)
	if node_file_name in material_associations:
		target_material = material_associations[node_file_name]
	# This only works if the node wasn't renamed, or has a number suffix.
	var node_name: String = c.name
	if node_name in material_associations:
		target_material = material_associations[node_name]
	# This is the preferred way and will override the rest.
	var node_type_variant: String = c.theme_type_variation
	if node_type_variant in material_associations:
		target_material = material_associations[node_type_variant]
	
	if target_material:
		node.material = target_material
