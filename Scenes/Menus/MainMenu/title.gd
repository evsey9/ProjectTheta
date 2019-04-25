extends Control
var leavescn = preload("res://Scenes/Menus/MainMenu/leaveconfirm.tscn")
var lines = []
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	lines = load_lines()
	print(lines)
	$mainMenu/start.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_leave_button_down():
	var lcn = leavescn.instance()
	$mainMenu.hide()
	lcn.connect("yes", self,"_on_leaveconf_yes")
	lcn.connect("no", self,"_on_leaveconf_no")
	add_child(lcn)
	#get_tree().quit()

func leaveconf_close(lcn : Control):
	$mainMenu/leave.grab_focus()
	lcn.queue_free()
	$mainMenu.show()
	
func _on_leaveconf_no(lcn : Control):
	leaveconf_close(lcn)

func _on_leaveconf_yes(lcn : Control):
	leaveconf_close(lcn)
	$AnimationPlayer.play("leave")
	$mainMenu/gameLogo.text = lines[randi()%len(lines)]

func _on_options_button_down():
	pass # Replace with function body.


func _on_credits_button_down():
	pass # Replace with function body.


func _on_start_button_down():
	pass # Replace with function body.

func quit():
	get_tree().quit()

func load_lines():
	var result = []
	var f = File.new()
	f.open("res://Scenes/Menus/MainMenu/leavelines.txt", File.READ)
	while not f.eof_reached():
		var res = f.get_line()
		print(res)
		result += [res]
	f.close()
	return result

