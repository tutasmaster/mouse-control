@tool

extends HBoxContainer
class_name CheckboxProperty
@export var min : float = 0.0
@export var max : float = 1.0
@export var step : float = 0.1
@export var prop_name : String = "PROPERTY"
@export var prop_value : bool = false

var value_box : CheckButton
var name_box : LineEdit
var menu = null

func _enter_tree() -> void:
	for c in get_children():
		c.queue_free()
	name_box = LineEdit.new()
	name_box.editable = false
	name_box.text = prop_name
	name_box.size_flags_horizontal = SIZE_EXPAND_FILL
	name_box.theme = theme
	add_child(name_box)
	value_box = CheckButton.new()
	value_box.toggled.connect(_on_checkbox_value_changed)
	value_box.button_pressed = prop_value
	value_box.theme = theme
	add_child(value_box)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if prop_name != name_box.text:
			name_box.text = prop_name
		if prop_value != value_box.button_pressed:
			value_box.set_pressed_no_signal(prop_value)
			
func set_value(value : bool):
	prop_value = value
	value_box.button_pressed = value
	
signal on_value_changed(value)
func _on_checkbox_value_changed(value):
	self.prop_value = value
	on_value_changed.emit()
	
