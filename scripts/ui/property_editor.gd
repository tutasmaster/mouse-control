@tool
extends ScrollContainer
class_name PropertyEditor

@export var autoload = true
@export var autoload_file = "property"

@export var params : Dictionary = {}
@export var file_prefix : String = "CATEGORY" 
@export var prefix : String = "CATEGORY_"
@export var extension : String = ".json"
@export var source : String = "user://"

func _enter_tree() -> void:
	reload_params()
			
func value_changed(node : Node):
	params[prefix + node.prop_name] = node.prop_value

var child_count : int = 0
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if(child_count != get_children()[0].get_child_count()):
			reload_params()
		
func reload_params():
	params = {}
	child_count = get_children()[0].get_child_count()
	for c in get_children()[0].get_children():
		if c is FloatProperty:
			params[prefix + c.prop_name] = c.prop_value
			if(!Engine.is_editor_hint()):
				c.on_value_changed.connect(value_changed.bind(c))
		if c is CheckboxProperty:
			params[prefix + c.prop_name] = c.prop_value
			if(!Engine.is_editor_hint()):
				c.on_value_changed.connect(value_changed.bind(c))

func save_file(file : String):
	var save_game = FileAccess.open(source + file_prefix + "_" + file + extension, FileAccess.WRITE)
	var json_string = JSON.stringify(params)
	save_game.store_line(json_string)
	
func load_file(file : String):
	if not FileAccess.file_exists(source + file_prefix + "_" + file + extension):
		return
	var save_game = FileAccess.open(source + file_prefix + "_" + file + extension, FileAccess.READ)
	if save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if parse_result != OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			return
		var data = json.get_data()
		params = data
		for c in get_children()[0].get_children():
			if c is FloatProperty || c is CheckboxProperty:
				if(params.has(prefix + c.prop_name)):
					var value = params[prefix + c.prop_name]
					if c is FloatProperty && value is float:
						c.set_value(value)
					if c is CheckboxProperty && value is bool:
						c.set_value(value)
