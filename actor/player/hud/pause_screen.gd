extends Control
@export var hud: Control
var IsPaused := false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		IsPaused = !IsPaused;
		visible = IsPaused
		var map : Map3D = hud.player.map;
		if map.type != 0: 
			get_tree().paused = IsPaused;
			$Label.visible = true;
		else:
			$Label.visible = false;
