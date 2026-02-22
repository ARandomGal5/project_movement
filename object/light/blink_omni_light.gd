extends OmniLight3D
class_name BlinkOmniLight3D
@export var infrequency := 1 ##Rolls a random number between 0 and this, if it lands on 0 toggle the light on/off to create a random blinking effect;
@export var seizure_safety := 45; ##Minimum time between blinks, if the light wants to blink and this time hasn't elapsed, skip. This is to prevent really fast blinking from sometimes happening
var time_since_blink := 0;

func _physics_process(_delta: float) -> void:
	time_since_blink += 1;
	if time_since_blink < seizure_safety:
		return;
	var blink_check = randi_range(0, infrequency);
	if blink_check == 0:
		visible = !visible;
		time_since_blink = 0;
