	extends KinematicBody2D

const GRAVITY_VEC = Vector2(0, 900)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const MIN_ONAIR_TIME = 0.1
const WALK_SPEED = 350 # pixels/sec
const JUMP_SPEED = 600
const SIDING_CHANGE_SPEED = 10
const BULLET_VELOCITY = 1000
const SHOOT_TIME_SHOW_WEAPON = 0.2
const SPRINT_MULT = 2
const SPRINT_JUMP_ADD = 1
const SPRINT_JUMP_TIME_COST = 1
const BASE_SPRINT = 5
const SPRINT_REGEN = 0.2
const SPRINT_REGEN_CD = 2
const MAX_FALL_SPEED = 1000
const MAX_RISE_SPEED = MAX_FALL_SPEED
var afterimage_scene = preload("Effects/afterimage.tscn")
var leaveafterimage = false
var timesinceaftim = 0
var timebetweenaft = 0.075
var sprint = false
var can_sprint = true
var sprinttime = BASE_SPRINT
var sprintcd = 0
var speedmult = 1
var sprintjump = false
var linear_vel = Vector2()
var onair_time = 0 #
var on_floor = false
var shoot_time = 99999 #time since last shot
var shoot = true
var act_shoot = false
var act_shoot_pressed = false
var act_move_left = false
var act_move_right = false
var act_jump = false
var act_jump_pressed = false
var act_jump_released = false
var act_sprint = false

var anim=""

#cache the sprite here for fast access (we will set scale to flip it often)
onready var sprite = $sprite
func _ready():
	pass
	#add_to_group("player")
func _physics_process(delta):
	#increment counters
	timesinceaftim += delta
	onair_time += delta
	shoot_time += delta

	### MOVEMENT ###

	# Apply Gravity
	linear_vel += delta * GRAVITY_VEC
	linear_vel.y = clamp(linear_vel.y,-MAX_RISE_SPEED,MAX_FALL_SPEED)
	# Move and Slide
	linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	# Detect Floor
	if is_on_floor():
		onair_time = 0

	on_floor = onair_time < MIN_ONAIR_TIME
	speedmult = 1
	### CONTROL ###
	act_shoot_pressed = false
	act_jump_pressed = false
	act_jump_released = false
	_handle_acts()
	# Horizontal Movement
	var target_speed = 0
	if act_move_left:
		target_speed += -1
	if act_move_right:
		target_speed +=  1
	# Sprinting
	if act_sprint and can_sprint and target_speed:
		sprint = true
	else:
		
		sprint = false
	if sprint:
		leaveafterimage = true
		sprintcd = SPRINT_REGEN_CD
		speedmult = 2
		sprinttime -= delta
		if sprinttime <= 0:
			can_sprint = false
	else:
		leaveafterimage = false
		if sprintcd <= 0:
			sprinttime = min(sprinttime + BASE_SPRINT * SPRINT_REGEN * delta, BASE_SPRINT)
	if sprinttime < BASE_SPRINT:
		$sprintbar.visible = true
		$sprintbar.value = sprinttime / BASE_SPRINT * 100
	else:
		$sprintbar.visible = false
	if sprintcd > 0:
		sprintcd -= delta
	if !can_sprint:
		if sprinttime >= BASE_SPRINT:
			can_sprint = true
	target_speed *= WALK_SPEED * speedmult
	linear_vel.x = lerp(linear_vel.x, target_speed, 0.3)
	# Jumping
	if on_floor and act_jump_pressed:
		linear_vel.y = -JUMP_SPEED
		if sprint:
			sprinttime -= SPRINT_JUMP_TIME_COST
			var sprinttaken = 1
			if sprinttime < 0:
				sprinttaken = (SPRINT_JUMP_TIME_COST + sprinttime) / SPRINT_JUMP_TIME_COST
			print("sprtaken: "+str(sprinttaken))
			linear_vel.y += -JUMP_SPEED * SPRINT_JUMP_ADD * sprinttaken
			sprintjump = true
		$sound_jump.play()
	if act_jump_released:
		linear_vel.y = max(linear_vel.y,0)
	if sprintjump:
		leaveafterimage = true
	# Shooting
	if act_shoot_pressed:
		shoot = true
	else:
		shoot = false
	if shoot:
		var bullet = preload("res://Scenes/Objects/Projectiles/Bullet/bullet.tscn").instance()
		bullet.position = $sprite/bullet_shoot.global_position #use node for shoot position
		bullet.movevec = Vector2(sprite.scale.x , 0).normalized()
		bullet.speed = BULLET_VELOCITY
		bullet.add_collision_exception_with(self) # don't want player to collide with bullet
		#if $sprite.scale.x == -1:
		#	bullet.rotation = PI
		get_parent().add_child(bullet) #don't want bullet to move with me, so add it as child of parent
		$sound_shoot.play()
		shoot_time = 0

	### ANIMATION ###

	var new_anim = "idle"

	if on_floor:
		sprintjump = false
		if linear_vel.x < -SIDING_CHANGE_SPEED:
			sprite.scale.x = -1
			new_anim = "run"

		if linear_vel.x > SIDING_CHANGE_SPEED:
			sprite.scale.x = 1
			new_anim = "run"
	else:
		# We want the character to immediately change facing side when the player
		# tries to change direction, during air control.
		# This allows for example the player to shoot quickly left then right.
		if act_move_left and not act_move_right:
			sprite.scale.x = -1
		if act_move_right and not act_move_left:
			sprite.scale.x = 1

		if linear_vel.y < 0:
			new_anim = "jumping"
		else:
			new_anim = "falling"
	if shoot_time < SHOOT_TIME_SHOW_WEAPON:
		new_anim += "_weapon"

	if new_anim != anim:
		anim = new_anim
		$anim.play(anim)
	#afterimage
	if leaveafterimage:
		if timesinceaftim >= timebetweenaft:
			var aftsc = afterimage_scene.instance()
			aftsc.position = self.position
			aftsc.frame = $sprite.frame
			aftsc.scale = $sprite.scale
			aftsc.self_modulate = $sprite.self_modulate
			aftsc.self_modulate.a = 0.5
			get_parent().add_child(aftsc)
			timesinceaftim = 0

func _handle_acts():
	act_move_left = false
	act_move_right = false
	act_jump = false
	act_jump_pressed = false
	act_jump_released = false
	act_shoot = false
	act_shoot_pressed = false
	act_sprint = false
	#Put all the AI logic in here for the robot to decide where to go. Example:
	#act_move_left = Input.is_action_pressed("move_left")
	#act_move_right = Input.is_action_pressed("move_right")
	#act_jump = Input.is_action_pressed("jump")
	#act_jump_pressed = Input.is_action_just_pressed("jump")
	#act_jump_released = Input.is_action_just_released("jump")
	#act_shoot = Input.is_action_just_pressed("shoot")
	#act_sprint = Input.is_action_pressed("sprint")