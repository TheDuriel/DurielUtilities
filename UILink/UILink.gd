class_name UILink
extends RefCounted

# These constants represent a useful set of common properties
# You can add your own

const CONTROL_POSITION: String = "position"
const CONTROL_GLOBAL_POSITION: String = "global_position"
const CONTROL_ROTATION: String = "rotation"
const CONTROL_SCALE: String = "scale"
const CONTROL_TOOLTIP_TEXT: String = "tooltip_text"
const CONTROL_VISIBLE: String = "visible"

const BUTTON_BUTTON_PRESSED: String = "button_pressed"
const BUTTON_DISABLED: String = "disabled"

const COLORRECT_COLOR: String = "color"

const LABEL_TEXT: String = "text"

const LINEEDIT_EDITABLE: String = "editable"
const LINEEDIT_MAX_LENGHT: String = "max_length"
const LINEEDIT_SECRET: String = "secret"
const LINEEDIT_TEXT: String = "text"

const RANGE_MAX_VALUE: String = "max_value"
const RANGE_MIN_VALUE: String = "min_value"
const RANGE_VALUE: String = "value"

const TEXTURERECT_TEXTURE: String = "texture"

const TABCONTAINER_CURRENT_TAB: String = "current_tab"


# Creates an object which will observe the properties of a target control node.
# And updates the target property in the target object every process frame
static func observe(observer: Object, target_control: Control, property_id: String, observer_property_name: String) -> UILinkObserver:
	if not observer_property_name in observer:
		Logger.warn(observer, observe, "Property %s does not exist in object %s" % [observer_property_name, observer])
		return null
	if not property_id in target_control:
		Logger.warn(observer, observe, "Property %s does not exist in target %s" % [property_id, target_control])
		return null
	
	var types: Array[int] = [typeof(target_control[property_id]), typeof(observer[observer_property_name])]
	if not types[0] == types[1]:
		Logger.warn(observer, observe, "Target property type %s does not match observer property type %s" % types)
		return null
	
	var uilo: UILinkObserver = UILinkObserver.new(observer, target_control, property_id, observer_property_name)
	return uilo


# Creates an object which will control the properties of a target control node.
# And updates the controls property with the value of the origin object every frame.
static func control(controller: Object, target_control: Control, property_id: String, controller_property_name: String) -> UILinkController:
	if not controller_property_name in controller:
		Logger.warn(controller, observe, "Property %s does not exist in object %s" % [controller_property_name, controller])
		return null
	if not property_id in target_control:
		Logger.warn(controller, observe, "Property %s does not exist in target %s" % [property_id, target_control])
		return null
	
	var types: Array[int] = [typeof(target_control[property_id]), typeof(controller[controller_property_name])]
	if not types[0] == types[1]:
		Logger.warn(controller, observe, "Target property type %s does not match controller property type %s" % types)
		return null
	
	var uilc: UILinkController = UILinkController.new(controller, target_control, property_id, controller_property_name)
	return uilc
