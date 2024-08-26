extends Control



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bus = AudioServer.get_bus_index("Music")
	var bus2 = AudioServer.get_bus_index("SFX")
	$PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/VSlider2.value = db_to_linear(AudioServer.get_bus_volume_db(bus))
	$PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/VSlider3.value = db_to_linear(AudioServer.get_bus_volume_db(bus2))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_v_slider_value_changed(value: float) -> void:
	GameManager.set_master_volume(value)


func _on_credits_pressed() -> void:
	$PanelContainer.hide()
	$PanelContainer2.show()
	$PanelContainer2/VBoxContainer/Button.grab_focus()
	pass # Replace with function body.


func _on_close_credits_pressed() -> void:
	$PanelContainer.show()
	$PanelContainer2.hide()
	$PanelContainer/VBoxContainer/Button2.grab_focus()
	pass # Replace with function body.


func _on_debug_pressed() -> void:
	GameManager.toggle_debug()
	pass # Replace with function body.


func _on_v_slider_2_value_changed(value: float) -> void:
	GameManager.set_music_volume(value)


func _on_v_slider_3_value_changed(value: float) -> void:
	GameManager.set_sfx_volume(value)


func _on_reset_pressed() -> void:
	hide()
	get_tree().reload_current_scene()
	pass # Replace with function body.
