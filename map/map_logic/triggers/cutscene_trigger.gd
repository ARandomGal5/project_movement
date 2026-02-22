extends Trigger3D
class_name CutsceneTrigger3D
@export var animation_player: AnimationPlayer
@export var anim_name := ""

func _activate(body: CollisionObject3D):
	animation_player.play(anim_name);
