extends CharacterBody3D
class_name Rat
@export var path : Path

var SPEED = 40.0
const JUMP_VELOCITY = 4.5

var current_path = 0
var stamina = 1.0
var stagger = 1.0
var enabled = true

func _ready():
	GameManager.rat = self

var accum = 0.0

func _physics_process(delta: float) -> void:
	stagger += delta * 0.5
	stagger = min(1,stagger)
	accum += delta
	if(stagger == 1 && $HurtSprite.visible):
		$HurtSprite.hide()
	if not enabled:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * 3 * delta
		
		move_and_slide()
		return
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var input_dir = Vector2(sin(accum) * 0.001 * velocity.length(),1)
	var path_child = path.get_children()[current_path]
	var d = Vector2(global_position.x - path_child.global_position.x,global_position.z - path_child.global_position.z).normalized()
	quaternion = quaternion.slerp(Quaternion.from_euler(Vector3(0, atan2(d.x, d.y) - PI, 0)),min(1,delta*5))
	
	if(path.get_children()[current_path].has_meta("Reverse")):
		$rat.rotation.y = lerpf($rat.rotation.y,0,min(1,delta*5))
	else:
		$rat.rotation.y = lerpf($rat.rotation.y,-PI,min(1,delta*5))
		
	#global_rotation.y = atan2(d.x, d.y) - PI
	if(GameManager.debug):
		DebugDraw3D.draw_line(global_position, path_child.global_position, Color.AQUA)
	var new_pos = path.curve.sample_baked(path.curve.get_closest_offset(global_position))
	new_pos.y = global_position.y
	global_position = global_position.lerp(new_pos,delta)
	if(global_position.distance_to(path_child.global_position) < 2):
		current_path += 1
		if(current_path <= path.get_children().size() - 1 && path.get_children()[current_path].has_meta("Teleport")):
			global_position = path.get_children()[current_path].global_position
			current_path += 1
		if(current_path > path.get_children().size() - 1):
			current_path = 0
		if(path.get_children()[current_path].has_meta("Impulse")):
			velocity.y += path.get_children()[current_path].get_meta("Impulse")
			move_and_slide()
			return
		
		
	
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#RUBBERBANDING TIME
	var distance = GameManager.player.global_position.distance_to(global_position)*(0.05*(1.3-stamina) )
	SPEED = clamp(60/distance,0,500)
	
	if direction:
		var accel = min(1800,SPEED * (1.3-stamina)* 10)
		velocity.x += direction.x * accel * delta
		velocity.z += direction.z * accel * delta
		velocity *= 0.5
		velocity *= stagger
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	
	move_and_slide()

func hit():
	$HurtSprite.show()
	stamina -= 0.225
	stagger = 0
	$Squeak.play()
	velocity = -(global_position - GameManager.player.global_position).normalized()*20
	if(stamina <= 0):
		GameManager.stop_timer()
		get_tree().paused = true
		GameManager.fade_out()
		#get_tree().change_scene_to_file.call_deferred("res://cutscene.tscn")
