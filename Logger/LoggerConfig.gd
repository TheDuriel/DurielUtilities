class_name LoggerConfig
extends Resource
## Game Config Resource
##
## A simple resource which can be loaded in various parts of your app to apply configurations.
## The default location is res://app_config.tres.

@export_category("Logging")
@export var log_confirms: bool = false
@export var log_hints: bool = false
@export var log_warnings: bool = true
@export var log_errors: bool = true
@export var assert_errors: bool = true
