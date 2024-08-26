extends HBoxContainer
class_name FileOptions

signal on_save(file : String)
signal on_load(file : String)

@onready var file : LineEdit = $"FILE"

func save():
	on_save.emit(file.text)

func load():
	on_load.emit(file.text)
