extends CharacterBody3D
class_name Player

var speed = Vector2()
var acceleration = 0.8
var rot_velocity = 5
var drag = 0.95
var air_drag = 0.98
@onready var model = $"cat"
const JUMP_VELOCITY = 4.5

var is_pouncing = false
var is_eating_rat = false

func enable_hitbox():
	$Area3D.monitoring = true
	
func disable_hitbox():
	$Area3D.monitoring = false
	

func _ready():
	GameManager.player = self
	GameManager.timer = 0
	GameManager.start_timer()
	$AudioStreamPlayer3D2.play()

var _HELP_set_acceleration = "Sets the acceleration of the cat"
func set_acceleration(value : float):
	acceleration = value
var _HELP_set_drag = "Sets the drag of the cat"
func set_drag(value : float):
	drag = value

var is_hit = false
var pounce_accum = 0
func _physics_process(delta: float) -> void:
	$AnimationTree.set("parameters/Run/blend_amount",min(1,velocity.length()/5))
	$AnimationTree.set("parameters/Sideways/blend_amount",velocity.normalized().dot(basis.x) * min(1,velocity.length()/5))
	
	if(GameManager.debug):
		DebugDraw3D.draw_arrow(global_position + Vector3(0,1,0), global_position + Vector3(0,1,0) + velocity, Color.GREEN,0.1)
		DebugDraw3D.draw_arrow(global_position + Vector3(0,1,0), global_position + Vector3(0,1,0) - velocity * (1.0-drag), Color.RED,0.1)
		DebugDraw3D.draw_arrow(global_position + Vector3(0,2,0), global_position + Vector3(0,2,0) + velocity.normalized(), Color.BLUE,0.1)
	
	if not is_on_floor():
		velocity += get_gravity() * 3 * delta
	
	if($RayCast3D.is_colliding() && velocity.normalized().dot(-$RayCast3D.global_basis.y) > 0.7 && velocity.length() > 15):
		is_pouncing = false
		is_hit = true
		velocity = Vector3.ZERO
		$AnimationTree.set("parameters/Hit/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		$Hurt.play()
		disable_hitbox()
		$HurtSprite.show()
		$AnimationTree.set("parameters/OneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
		return
	if(is_pouncing):
		pounce_accum = 0
		if(!$AnimationTree.get("parameters/OneShot/active")):
			is_pouncing = false
		else:
			velocity *= air_drag
			move_and_slide()
			return
	if(is_hit):
		
		pounce_accum = 0
		if(!$AnimationTree.get("parameters/Hit/active")):
			is_hit = false
			
			$HurtSprite.hide()
		else:
			velocity *= air_drag
			move_and_slide()
			return
	if(Input.is_action_pressed("pounce")):
		pounce_accum = lerpf(pounce_accum, 1.0, min(1.0,delta*2))
	else:
		pounce_accum = 0.0
	$AnimationTree.set("parameters/PounceBlend/blend_amount",min(1.0,pounce_accum * maxf(0,(10.0 - velocity.length())/10.0)))
	if(Input.is_action_just_released("pounce")):
		$Pounce.play()
		velocity -= transform.basis.z * 20
		#velocity += Vector3(0,5,0)
		is_pouncing = true
		move_and_slide()
		$AnimationTree.set("parameters/OneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		return
	#var effect : AudioEffectPitchShift = AudioServer.get_bus_effect(AudioServer.get_bus_index("Footsteps"),0)
	var d = velocity.normalized().dot(basis.x) * min(1,velocity.length()/5)
	#effect.pitch_scale = clamp((velocity.length()/15) + d * 5,0.1,5)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Footsteps"),linear_to_db(1 if velocity.length() > 1 else velocity.length()))
	var camera = GameManager.camera
	var cam_forward = camera.global_basis.z
	cam_forward.y = 0
	cam_forward = cam_forward.normalized()
	# Add the gravity.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "backwards", "forwards")
	
	input_dir.x *= 0.5
	var target_rot : float = GameManager.camera.rotation.y
	
	var sfx_index= AudioServer.get_bus_index("Purr")
	AudioServer.set_bus_volume_db(sfx_index, linear_to_db(abs(velocity.normalized().dot(basis.x) * min(1,velocity.length()/5))))
	
	quaternion = quaternion.slerp(Quaternion.from_euler(Vector3(rotation.x,target_rot,rotation.z)),min(1,delta*5))
	#var target_rot = input_dir.x
	#model.rotation.y = lerp(model.rotation.y,target_rot,delta*5)
	#rotate_y(input_dir.x * delta * rot_velocity)
	#speed += input_dir.y * delta * acceleration
	speed *= 0.99
	velocity += transform.basis.x * input_dir.x * acceleration
	velocity += -transform.basis.z * input_dir.y * acceleration
	if(GameManager.debug):
		DebugDraw3D.draw_arrow(global_position + Vector3(0,1,0), global_position + Vector3(0,1,0) + velocity, Color.GREEN,0.1)
		DebugDraw3D.draw_arrow(global_position + Vector3(0,1,0), global_position + Vector3(0,1,0) - velocity * (1.0-drag), Color.RED,0.1)
		DebugDraw3D.draw_arrow(global_position + Vector3(0,2,0), global_position + Vector3(0,2,0) + velocity.normalized(), Color.BLUE,0.1)
	
	
	velocity *= drag
	#velocity = -transform.basis.z * speed
	
	move_and_slide()


func _on_hit(body: Node3D) -> void:
	if(body.name == "Rat"):
		is_eating_rat = true
		body.hit()
		
