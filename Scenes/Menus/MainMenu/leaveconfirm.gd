extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal yes
signal no
# Called when the node enters the scene tree for the first time.
func _ready():
	$yes.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_yes_button_down():
	emit_signal("yes", self)


func _on_no_button_down():
	emit_signal("no", self)
