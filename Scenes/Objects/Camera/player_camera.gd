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
	var relpos = position + get_viewport_rect().size / 2
	position = lerp(relpos,player.position,0.5) - get_viewport_rect().size / 2
