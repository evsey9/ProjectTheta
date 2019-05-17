extends "res://Scenes/Objects/RobotBase/robotbase.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass
	#_handle_acts()

func _handle_acts():
	act_move_left = Input.is_action_pressed("move_left")
	act_move_right = Input.is_action_pressed("move_right")
	act_jump = Input.is_action_pressed("jump")
	act_jump_pressed = Input.is_action_just_pressed("jump")
	act_jump_released = Input.is_action_just_released("jump")
	act_shoot = Input.is_action_pressed("shoot")
	act_shoot_pressed = Input.is_action_just_pressed("shoot")
	act_sprint = Input.is_action_pressed("sprint")