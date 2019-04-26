extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var col : KinematicCollision2D
var movevec : Vector2 = Vector2(0,0) 
var speed = 10
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	col = move_and_collide(movevec * speed * delta)
	if col:
		hit(col.collider)

func hit(body):
	if body.has_method("hit_by_bullet"):
		body.call("hit_by_bullet")
	queue_free()
func _on_Timer_timeout():
	queue_free()
