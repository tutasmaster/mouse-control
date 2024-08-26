extends Node3D
@export var target : Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reparent.call_deferred(target)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = Vector3.ZERO
	
	pass
