extends Area2D

var taken : bool = false

func _on_coin_body_enter(body):
	if not taken and body.is_in_group("player"):
		$anim.play("taken")
		taken = true
