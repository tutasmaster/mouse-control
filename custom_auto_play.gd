extends AnimationPlayer
@export var animation : String = "START"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play(animation)
