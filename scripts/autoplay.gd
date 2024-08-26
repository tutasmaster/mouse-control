extends AnimationPlayer

func _ready() -> void:
	play("splash")

func startGame():
	GameManager.fade_in()
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://main.tscn")
	
func startCutscene():
	GameManager.fade_in()
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file.call_deferred("res://cutscene.tscn")
	delete()

func delete():
	get_parent().queue_free()
