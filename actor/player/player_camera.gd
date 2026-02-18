extends Camera3D
@export var player: Player3D
var standing_camera_pos := 0.5;
var crouched_camera_pos := -0.2;
var camera_crouch_shift_speed := 0.1;

var DebugThirdPerson := false;
var normal_pos := -0.25;
var debug_pos := 2;

func _physics_process(_delta: float) -> void:
	_do_view_roll();
	_set_camera_position();
	_debug_third_person();
	
func _do_view_roll():
	#Return if the player has viewroll disabled
	if Game.settings.view_roll_degrees < 0:
		return;
	#Get an axis based on the player's horizontal movement input
	var axis = Input.get_axis("left", "right");
	#If the player is moving horizontally, rotate towards the desired rotation in the direction they're moving
	if abs(axis) > 0:
		rotation.z = move_toward(rotation.z, deg_to_rad(Game.settings.view_roll_degrees)*-axis, Game.settings.view_roll_speed);
	#Otherwise reset it to 0
	else:
		rotation.z = move_toward(rotation.z, 0, Game.settings.view_roll_speed);

#Mainly for moving the camera when the player crouches
func _set_camera_position():
	if player.IsCrouched && !player.IsCrouchJumped:
		position.y = move_toward(position.y, crouched_camera_pos, camera_crouch_shift_speed);
	else:
		position.y = move_toward(position.y, standing_camera_pos, camera_crouch_shift_speed);

func _debug_third_person():
	if !Input.is_action_just_pressed("third_person"):
		return;
	DebugThirdPerson = !DebugThirdPerson;
	if DebugThirdPerson:
		position.z = normal_pos;
	else:
		position.z = debug_pos;
