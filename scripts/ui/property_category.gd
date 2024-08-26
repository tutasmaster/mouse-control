@tool
extends HBoxContainer
class_name PropertyCategory

@onready var name_box : Label = $PROPERTY_NAME
@export var prop_name : String = "PROPERTY_NAME"

func _enter_tree() -> void:
	for c in get_children():
		c.queue_free()
	name_box = Label.new()
	name_box.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	name_box.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_box.theme = theme
	name_box.text = prop_name
	add_child(name_box)
