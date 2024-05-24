class_name iPopupBinary
extends BasePopup

enum RESULT {A, B}

signal handled(result: RESULT)

@export var header: Label
@export var option_a: Button
@export var option_b: Button


func _ready() -> void:
	option_a.pressed.connect(_on_option_pressed.bind(RESULT.A))
	option_b.pressed.connect(_on_option_pressed.bind(RESULT.B))


func set_config(config: PopupConfigurationBinary) -> void:
	header.text = config.header
	option_a.text = config.option_a
	option_b.text = config.option_b


func _on_option_pressed(result: RESULT) -> void:
	closed.emit()
	handled.emit(result)
