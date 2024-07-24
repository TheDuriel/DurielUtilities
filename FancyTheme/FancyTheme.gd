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
@export var material_associations: Dictionary = {} # Control Type : Material


func _init() -> void:
	# Subscribe to the adding of ANY node to the tree.
	var main_loop: MainLoop = Engine.get_main_loop()
	if main_loop is SceneTree:
		main_loop.node_added.connect(_on_node_added)


func _on_node_added(node: Node) -> void:
	if not node is Control:
		return
	
	# This only works if get_class is defined or it is a built in node.
	var node_class: String = node.get_class()
	# This only works if the node has a script, returns get_class() otherwise.
	var node_file_name: String = Logger.get_object_file_name(node)
	# This only works if the node wasn't renamed, or has a number suffix.
	var node_name: String = node.name
	
	var possible_names: Array[String] = []
	if node_class: possible_names.append(node_class)
	if node_file_name: possible_names.append(node_file_name)
	if node_name: possible_names.append(node_name)
	
	for name: String in possible_names:
		if name in material_associations:
			#node.set.call_deferred("material", material_associations[name])
			node.material = material_associations[name]
			print("applied %s" % node.get_path())
			return
