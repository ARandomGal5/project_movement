extends Node3D
class_name Map3D
@export_enum("Station", "Train") var type = 0;
@export_range(0, 3600, 1, "suffix:seconds") var timer := 0.0
@export var timer_multiplier := 1;
var frame_timer := 0.0;
var tick_rate := 0;

func _ready():
	tick_rate = ProjectSettings.get_setting("physics/common/physics_ticks_per_second")
	frame_timer = timer*tick_rate;
	
func _physics_process(_delta: float) -> void:
	_handle_timer();

func _handle_timer():
	frame_timer -= timer_multiplier;
	if type != 0: return;
