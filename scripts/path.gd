@tool
extends Node3D
class_name Path

@export var pointList : Array[Vector3]
@export var curve : Curve3D = Curve3D.new()
func _ready():
	if !Engine.is_editor_hint():
		pointList = []
		curve.clear_points()
		for c in get_children():
			pointList.push_back(c.global_position)
			curve.add_point(c.global_position)
		pointList.push_back(get_children()[0].global_position)
		curve.add_point(get_children()[0].global_position)
		
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		pointList = []
		curve.clear_points()
		for c in get_children():
			pointList.push_back(c.global_position)
			curve.add_point(c.global_position)
		pointList.push_back(get_children()[0].global_position)
		curve.add_point(get_children()[0].global_position)
		DebugDraw3D.draw_arrow_path(pointList, Color.CYAN)
	else:
		if(GameManager.debug):
			DebugDraw3D.draw_arrow_path(pointList, Color.CYAN)
	pass
