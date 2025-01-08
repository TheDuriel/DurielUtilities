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
