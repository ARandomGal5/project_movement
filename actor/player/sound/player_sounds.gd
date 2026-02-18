extends Node3D
@export var step_time_max := 0;
@export var player: Player3D
@export var footstep: AudioStreamPlayer3D;
@export var footstep2: AudioStreamPlayer3D;
@export var floor_check: RayCast3D
var step_time := 0.0;
var floor_time := 0;
var land_sound_delay := 5;
var prev_fall_speed := 0;
var prev_stream_path := "";
var StepLeft := false;

func _physics_process(_delta: float) -> void:
	_handle_footsteps();
	_handle_landing_step();

func _handle_footsteps():
	#Reset the timer and return if the player isn't on the ground.
	if !player.is_on_floor():
		step_time = 0;
		return;
	#Get the footstep material string with a function
	var material = get_step_material();
	#Insert it into the audio stream randomizer file path template to get the correct path
	var stream_path = "res://actor/player/sound/footstep/" + material + "/step_" + material + ".tres";
	#Check if the path is different than the one the player is currently using
	if stream_path != prev_stream_path:
		#Update audio stream players
		footstep.set_stream(load(stream_path));
		footstep2.set_stream(load(stream_path));
		prev_stream_path = stream_path;
	#Add the player's velocity to the step timer to make it so the faster they're moving the faster footsteps play (remove vertical movement from the length, creating a 2D vector)
	step_time += Vector2(player.velocity.x, player.velocity.z).length();
	#Once it's reached the arbitrary timer, play a footstep and count up again.
	if step_time >= step_time_max:
		if StepLeft:
			footstep.play();
		else:
			footstep2.play();
		StepLeft = !StepLeft
		step_time = 0;
	
func _handle_landing_step():
	#When the player lands on the floor, play two footsteps, with a delay between them, to simulate landing footsteps.
	#We check this by incrementing a timer on the ground that resets in the air, and checking it's value
	if player.is_on_floor():
		if floor_time == 0:
			footstep.play();
		#Second step node is just for this lol (playing two steps at once)
		if floor_time == land_sound_delay && prev_fall_speed > 5:
			footstep2.play();
		floor_time += 1;
	else:
		prev_fall_speed = abs(player.velocity.y);
		floor_time = 0;

func get_step_material() -> String:
	#If the surface checking raycast isn't colliding (player is in air), return a fallback material
	if !floor_check.get_collider():
		return "concrete";
	#Get the mesh of the geometry the player is colliding with
	var mesh: ArrayMesh = floor_check.get_collider().get_parent().get_mesh()
	#If no valid metadata can be found from the top surface, push a warning and return a fallback
	if !mesh.surface_get_material(mesh.get_surface_count() - 1).get_meta("extras", null):
		push_warning("No valid material")
		return "concrete"
	##FUCK YOU BALTIMORE, GO MY 6 REFERENCES DEEP MATERIAL GETTER
	return mesh.surface_get_material(mesh.get_surface_count() - 1).get_meta("extras", null).material;
	
