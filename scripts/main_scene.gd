extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.pausing_enabled = true
	GameManager.stop_timer()
	GameManager.debug = false
	GameManager.fade_in()
	if(OS.has_feature("x86")):
		get_node("/root/Node3D/DesktopSetup").visible = true
		get_node("/root/Node3D/WebSetup").queue_free()
		get_node("/root/Node3D/LightmapGI").queue_free()
	elif(OS.has_feature("web")):
		get_node("/root/Node3D/DesktopSetup").queue_free()
		get_node("/root/Node3D/WebSetup").visible = true
		get_node("/root/Node3D/LightmapGI").visible = true
	get_tree().paused = false
	GameManager.start_timer()
	pass # Replace with function body.

func changeToCam1():
	var final_text = ""
	if(GameManager.timer != 0):
		var minutes = int(GameManager.timer / 60)
		var seconds = int(GameManager.timer) - (minutes * 60)
		if(minutes > 0):
			final_text += str(minutes) + " minutes"
			if(seconds > 0):
				final_text += " and "
		if(seconds > 0):
			final_text += str(seconds) + " seconds"
		if(minutes == 0 && seconds == 0):
			final_text += str(seconds) + " seconds"
	else:
		final_text = "no time at all"
	$Control/PanelContainer/VBoxContainer/Label.text = "It took you " + final_text + " to catch that mouse.\nThanks for playing!"
	$Control.hide()
	$Camera3D.make_current()
	

func changeToCam2():
	$Camera3D2.make_current()
	
	
func changeToCam3():
	$Camera3D3.make_current()
	
func changeToFinalCam():
	$Camera3D4.make_current()
	$Control.show()
	$Control/PanelContainer/VBoxContainer/Button.grab_focus()
	pass

func restart_game():
	get_tree().change_scene_to_file("res://splash.tscn")

func drown_rat():
	$rat/AudioStreamPlayer3D.play()
func hit_rat():
	$rat/Wall.play()
func slap_rat():
	$rat/Punch.play()
func trash():
	$trashcan/AudioStreamPlayer.play()
func footsteps_start():
	$cat2/AudioStreamPlayer.play()
func footsteps_end():
	$cat2/AudioStreamPlayer.stop()
