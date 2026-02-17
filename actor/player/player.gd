extends CharacterBody3D
class_name Player3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

#Use export variables to get nodes to avoid dealing with node path tomfoolery
@export var camera: Camera3D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	_do_view_roll();
	move_and_slide()

func _do_view_roll():
	if Game.settings.view_roll < 0:
		return;
	var axis = Input.get_axis("left", "right");
	var view_roll_speed := 0.01;
	if abs(axis) > 0:
		camera.rotation.z = move_toward(camera.rotation.z, deg_to_rad(Game.settings.view_roll)*-axis, view_roll_speed);
	else:
		camera.rotation.z = move_toward(camera.rotation.z, 0, view_roll_speed);

##Thank you kids can code very cool https://kidscancode.org/godot_recipes/4.x/3d/basic_fps/
func _input(event: InputEvent) -> void:
	#Return if the input event isn't the player moving the mouse
	if event is not InputEventMouseMotion:
		return;
	rotate_y(-event.relative.x * Game.settings.mouse_sensitivity)
	camera.rotate_x(-event.relative.y * Game.settings.mouse_sensitivity)
	camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2);
