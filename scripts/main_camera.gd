extends Node3D


var offset = Vector3()
var rot_x : float = 0
var original_rot : Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.camera = self
	original_rot = $SpringArm3D/Camera3D.rotation
	rot_x = -rotation.y
	offset = global_position - GameManager.player.global_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_position = global_position.lerp(GameManager.player.global_position,min(1,delta*20))
	rot_x += Input.get_axis("cam_left","cam_right") * delta * 5
	quaternion = quaternion.slerp(Quaternion.from_euler(Vector3(0,-rot_x,0)),min(1,delta*20))
	var vel = 0.1
	if(Input.is_action_pressed("pounce")):
		#$Target.look_at(GameManager.rat.global_position)
		pass
	else:
		$Target.rotation = original_rot
		vel = 20
	$SpringArm3D/Camera3D.quaternion = $SpringArm3D/Camera3D.quaternion.slerp($Target.quaternion, min(1,delta * vel))
	pass
