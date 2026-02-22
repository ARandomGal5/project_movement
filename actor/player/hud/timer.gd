extends RichTextLabel
@export var hud: Control
var map: Map3D
var frames_remaining := 120;
var seconds_remaining := 59;
var minutes_remaining := 0;
var tick_rate := 0;
var base_font_size := 128;
var font_scale := 1.0;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tick_rate = ProjectSettings.get_setting("physics/common/physics_ticks_per_second");
	#Get the map node
	map = hud.player.map;
	if map.type != 0:
		visible = false;
		return;
	#Add one because fuck you
	minutes_remaining = floor(map.timer/60);
	seconds_remaining = floor(map.timer - minutes_remaining*60);
	frames_remaining = tick_rate;
	#Calculate this only once at ready to reduce lag
	

func _physics_process(_delta: float) -> void:
	if map.type != 0:
		return;
	frames_remaining -= 1*map.timer_multiplier;
	if frames_remaining <= 0:
		seconds_remaining -= 1;
		frames_remaining = tick_rate
		if map.frame_timer == 60*tick_rate:
			$"1Min".play();
		$Tick.play();
	#Get a decimal scale that increases as the timer goes down to scale the timer text by
	var timer_intensity = map.timer*tick_rate/map.frame_timer*0.5;
	var desired_scale = Vector2(timer_intensity, timer_intensity);
	scale = desired_scale.clamp(Vector2(1, 1), Vector2(5, 5));
	modulate = Color(1, 2 - timer_intensity, 2 - timer_intensity)
	#Check for -1 instead of 0 so that at the end of a minute it displays 00
	#We basically do the whole 59 thing so that it displays as 5:00 instead of 4:60 lmao
	#This is also why we have to incrememnt the ready timer by 1 because otherwise 300 = 4:59 instead of 5:00
	if seconds_remaining <= -1:
		minutes_remaining -= 1;
		seconds_remaining = 59;
	var formatting := "[font_size=128][font=res://asset/font/Silver.ttf]"
	text = formatting + stringify(minutes_remaining) + ":" + stringify(seconds_remaining)
	

func stringify(value: float) -> String:
	#If the value is less than 10, add a 0 to the front
	if value >= 10:
		return str(int(value));
	else:
		return "0" + str(int(value));
