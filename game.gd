extends Node

var settings  = {
	"mouse_sensitivity" : 0.001,
	"view_roll_degrees" : 0,
	"view_roll_speed" : 0.01,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene();
