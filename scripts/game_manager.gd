extends Node


var rat : Rat
var last_set_db : float = 1.0
var player : Player
var camera : Node3D
var paused : bool = false
var debug : bool = true
var timer = 0
var timer_trigger = false
@onready var menu_prefab : PackedScene = load("res://scenes/main_menu.tscn")
@onready var fade_prefab : PackedScene = load("res://scenes/ui/fade_in.tscn")
@onready var fade_out_prefab : PackedScene = load("res://scenes/ui/fade_out.tscn")
var menu : Control
var pausing_enabled = false

func _ready() -> void:
	menu = menu_prefab.instantiate()
	add_child(menu)
	menu.visible = get_tree().paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	print(ProjectSettings.get_setting("rendering/renderer/rendering_method"))
	
func _process(delta: float) -> void:
	if(timer_trigger && !get_tree().paused):
		timer += delta
	if(pausing_enabled && Input.is_action_just_pressed("pause")):
		get_tree().paused = !get_tree().paused
		menu.visible = get_tree().paused
		if(get_tree().paused):
			menu.get_node("PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/VSlider").grab_focus()

func stop_timer():
	timer_trigger = false
	
func start_timer():
	timer_trigger = true


func fade_in():
	add_child(fade_prefab.instantiate())
func fade_out():
	add_child(fade_out_prefab.instantiate())

func toggle_debug():
	debug = !debug
	return debug

const _HELP_toggle_pause = "Enables/disables the pause menu."
func toggle_pause():
	paused = !paused
	return paused

const _HELP_pause = "Enables the pause menu."
func pause():
	paused = true
	return paused

const _HELP_unpause = "Disables the pause menu."
func unpause():
	paused = false
	return paused

const _HELP_ping = "This responds with pong."
func ping():
	print("pong")
	return "pong"

const _HELP_set_master_volume = "Sets the value for the main bus."
func set_master_volume(value : float):
	var bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus,linear_to_db(value))
	last_set_db = value
	return value
func set_sfx_volume(value : float):
	var bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus,linear_to_db(value))
	last_set_db = value
	return value

func set_music_volume(value : float):
	var bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus,linear_to_db(value))
	last_set_db = value
	return value
