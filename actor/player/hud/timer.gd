extends Label
@export var hud: Control
var map: Map3D
var mili_value := 100.0;
var second_value := 0.0;
var minute_value := 0.0;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Get the map node
	map = hud.player.map;


func _physics_process(_delta: float) -> void:
	#Get the amount of minutes left by dividing seconds left by 60
	minute_value = floor(map.timer/60)
	#Get the amount of seconds left by removing the total amount of minutes left times 60
	second_value = map.timer - minute_value * 60;
	#I was lazy and just put the miliseconds in the map script :P
	mili_value = map.millisecond_timer;
	text = stringify(minute_value) + ":" + stringify(second_value) + "." + stringify(snapped(map.millisecond_timer, 1));
	
func stringify(value: float) -> String:
	#Hack solution to fix miliseconds being triple digits, if it's at 100 just say it's 99 lol, you literally cannot tell cause how fast it is
	if value >= 100:
		return "99"
	#If the value is less than 10, add a 0 to the front
	if value >= 10:
		return str(int(value));
	else:
		return "0" + str(int(value));
	
