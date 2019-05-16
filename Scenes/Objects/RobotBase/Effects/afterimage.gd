extends Sprite
var timeup : float = 1.0 
var transpspeed : float = 1.0 / timeup
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.self_modulate.a -= transpspeed * delta
	if self.self_modulate.a <= 0:
		queue_free()
