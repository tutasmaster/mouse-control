
@tool

extends HBoxContainer
class_name FloatProperty
@export var min : float = 0.0
@export var max : float = 1.0
@export var step : float = 0.1
@export var prop_name : String = "PROPERTY"
@export var prop_value : float = 0.0

var value_box : SpinBox
var name_box : LineEdit
var menu = null

func _enter_tree() -> void:
	for c in get_children():
		c.queue_free()
	name_box = LineEdit.new()
	name_box.editable = false
	name_box.text = prop_name
	name_box.theme = theme
	name_box.size_flags_horizontal = SIZE_EXPAND_FILL
	add_child(name_box)
	value_box = SpinBox.new()
	value_box.value = prop_value
	value_box.value_changed.connect(_on_spin_box_value_changed)
	value_box.min_value = min
	value_box.max_value = max
	value_box.step = step
	value_box.value = prop_value
	value_box.theme = theme
	add_child(value_box)

func _process(delta: float) -> void:
	
	if Engine.is_editor_hint():
		if prop_name != name_box.text:
			name_box.text = prop_name
		if !is_equal_approx(value_box.value,prop_value) && prop_value >= min && prop_value <= max:
			value_box.value = prop_value
		if min != value_box.min_value:
			value_box.min_value = min
		if max != value_box.max_value:
			value_box.max_value = max
		if step != value_box.step && abs(step) < max - min:
			value_box.step = step
			
func set_value(value : float):
	prop_value = value
	value_box.value = value
	
signal on_value_changed(value)
func _on_spin_box_value_changed(value):
	self.prop_value = value
	on_value_changed.emit()
	
