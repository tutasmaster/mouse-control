extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var triggered = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(GameManager.player.global_position.distance_to($MeshInstance3D.global_position) < 2) and not triggered:
		play("rat_hole_pop_out")
		triggered = true
	pass
