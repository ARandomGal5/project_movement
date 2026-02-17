extends Node3D
class_name Map3D
@export_enum("Station", "Train") var type = 0;
@export_range(0, 3600, 1, "suffix:seconds") var timer := 0.0
var frame_timer := 0;
var millisecond_timer := 100.0;

func _physics_process(delta: float) -> void:
	frame_timer += 1;
	millisecond_timer -= 0.833333;
	if frame_timer >= 120:
		timer -= 1;
		frame_timer = 0;
		millisecond_timer = 100;
