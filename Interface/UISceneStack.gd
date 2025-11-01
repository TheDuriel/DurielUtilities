class_name UISceneStack
extends Control

signal scene_added(scene: UIScene)

## Automatically apply full rect anchors preset at _ready
@export var full_rect: bool = true


func _ready() -> void:
	if full_rect:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)


func has_scene(scene: UIScene) -> bool:
	return scene in get_children()


func stack_scene(scene: UIScene) -> void:
	var children: Array[Node] = get_children()
	
	if scene in children:
		DurielLogger.error(self, stack_scene, "Scene already in stack.")
		return
	
	for child: Node in children:
		if child is UIScene:
			child.suspend(self)
	
	scene.set_stack(self)
	add_child(scene)
	scene.move_to_front()
	
	scene_added.emit(scene)


func erase_scene(scene: UIScene) -> void:
	erase_scene_async.call_deferred(scene)


func erase_scene_async(scene: UIScene) -> void:
	if not scene in get_children():
		DurielLogger.error(self, stack_scene, "Scene not in stack.")
		return
	
	scene.free_scene.call_deferred()
	await scene.exit_animation_finished
	
	var children: Array[Node] = get_children()
	children.reverse()
	
	# Find the topmost valid scene in the stack, and unsuspend it.
	for child: Node in children:
		if not child is UIScene:
			continue
		if child == scene:
			continue
		if is_instance_valid(scene):
			scene.unsuspend(self)
			break
