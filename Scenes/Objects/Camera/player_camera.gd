extends Camera2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player")[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = lerp(position,player.position,0.5)
