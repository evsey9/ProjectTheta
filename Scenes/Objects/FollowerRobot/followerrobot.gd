extends "res://Scenes/Objects/RobotBase/robotbase.gd"
const STOP_RANGE = 50
const SPRINT_RANGE = 256
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player = get_tree().get_nodes_in_group("player")[0]
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("follower")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass

func _handle_acts():
	._handle_acts()
	var to_player = player.position - self.position
	if abs(to_player.x) > STOP_RANGE:
		if player.position > self.position:
			act_move_right = true
		else:
			act_move_left = true
		if abs(to_player.x) > SPRINT_RANGE:
			act_sprint = true
	if not is_on_floor():
		act_jump = true
		act_jump_pressed = true