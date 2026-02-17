extends CharacterBody3D
class_name Player3D

const SPEED = 5.0
const CROUCH_SPEED = 2.5;
const JUMP_VELOCITY = 4.5
const CROUCHED_HEIGHT := 0.9;
const STANDING_HEIGHT := 1.9;
var IsCrouched := false;
var IsCrouchJumped := false;
var CanUncrouch := true;
var desired_speed := 5.0;

#Use export variables to get nodes to avoid dealing with node path tomfoolery
@export var camera: Camera3D
@export var bounding_box: CollisionShape3D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	_apply_gravity(delta);
	_handle_movement_controls();
	move_and_slide()

func _apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

		
func _handle_movement_controls():
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if !IsCrouched:
		desired_speed = SPEED;
	elif is_on_floor():
		desired_speed = CROUCH_SPEED;
	if direction:
		velocity.x = direction.x * desired_speed
		velocity.z = direction.z * desired_speed
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	#If the player is moving faster than their current movement speed on the floor, slow them down
	if is_on_floor() && velocity.length() > desired_speed:
		velocity.move_toward(Vector3(desired_speed, 0, desired_speed)*velocity.normalized(), SPEED);
	_handle_jump();
	_handle_crouch();
	
func _handle_jump():
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
##Yummy spaghetti
func _handle_crouch():
	#Use a raycast to check if the player can uncrouch
	CanUncrouch = !$UncrouchCheck.is_colliding();
	#Check if the player crouches
	if Input.is_action_just_pressed("crouch"):
		#Set the player's bounding box to half its height
		bounding_box.shape.size.y = CROUCHED_HEIGHT;
		#If the player is on the ground, move the hitbox down to their bottom, otherwise move it to their top for crouch jumping.
		if is_on_floor(): 
			bounding_box.position.y -= CROUCHED_HEIGHT/2
			IsCrouchJumped = false
		else: 
			bounding_box.position.y += CROUCHED_HEIGHT/2
			IsCrouchJumped = true
		IsCrouched = true;
	#If the player uncrouches
	if !Input.is_action_pressed("crouch") && CanUncrouch:
		#Reset to normal height
		bounding_box.shape.size.y = STANDING_HEIGHT;
		#Reset the position back to normal
		bounding_box.position.y = 0;
		IsCrouched = false;
		#Remove the crouch jumped flag
		IsCrouchJumped = false;
	#If the player lands while crouch jumping
	if is_on_floor() && IsCrouchJumped:
		#Basically set them to a "normal" crouch where their hitbox is at their bottom, this is so uncrouching near a ledge doesn't fuck with you
		position.y += 1;
		bounding_box.position.y -= 1;
		#Snap the camera down to prevent jittering.
		camera.position.y = camera.crouched_camera_pos;
		IsCrouchJumped = false;
		
##Thank you kids can code very cool https://kidscancode.org/godot_recipes/4.x/3d/basic_fps/
func _input(event: InputEvent) -> void:
	#Return if the input event isn't the player moving the mouse
	if event is not InputEventMouseMotion:
		return;
	rotate_y(-event.relative.x * Game.settings.mouse_sensitivity)
	camera.rotate_x(-event.relative.y * Game.settings.mouse_sensitivity)
	camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2);
