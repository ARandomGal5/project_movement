extends Area3D
class_name Trigger3D

func _ready():
	body_entered.connect(_activate);
	get_child(0).debug_color = Color(1, 0.5, 0, 1)
	
func _activate(body: CollisionObject3D):
	pass;
