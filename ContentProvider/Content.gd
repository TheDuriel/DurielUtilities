# Content Autoload Script
extends Node

# Example implementation of a Content autoload that uses ResourceProviders

#const CONTENT_DIR: String = "res://Content/"
#const RESOURCE_EXTENSIONS: Array[String] = ["tres", "res"]
#const SCENE_EXTENSIONS: Array[String] = ["tscn", "scn"]
#const SCRIPT_EXTENSIONS: Array[String] = ["gd", "gdc"]

#const ACTOR_TEMPLATE_DIR: String = CONTENT_DIR + "ActorTemplates"


#var _actor_templates: ResourceProvider = ResourceProvider.new(ACTOR_TEMPLATE_DIR, RESOURCE_EXTENSIONS)


#func _init() -> void:
	#Logger.hint(self, _init, "Loaded %s ActorTemplates" % _actor_templates.get_count())


#func get_actor_template(file_name_without_extension: String) -> NemetonActorTemplate:
	#return _actor_templates.get_resource(file_name_without_extension) as NemetonActorTemplate


#func get_actor_template_async(file_name_without_extension: String) -> ResourcePromise:
	#return _actor_templates.get_resource_async(file_name_without_extension)

# Example use of threaded loading

#func _on_load_actor_pressed() -> void:
	#var promise: ResourcePromise = Content.get_actor_template_async("Ramina")
	#var status: ResourcePromise.STATUS = await promise.loading_finished
	#if status == ResourcePromise.STATUS.OK:
		#var template: ActorTemplate = promise.resource as ActorTemplate
	#else:
		#Logger.error(self, _on_load_actor_pressed, "Actor %s not found." % promise.resource_path)
