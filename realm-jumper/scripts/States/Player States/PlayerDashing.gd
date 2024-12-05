extends State
class_name PlayerDashing

var dash_direction : Vector2
var dash_timer
@export var max_dash_timer = 0.14

var player : Player

func Enter():
	player = get_node("../..")
	# Play Dash Audio
	player.audio_player.stream = preload("res://audio/sfx/sand-step.ogg")
	player.audio_player.pitch_scale = randf_range(1, 1.8)
	player.audio_player.play()
	
	player.jumping_from_wall = false
	dash_timer = max_dash_timer
	player.anim_player.play("dashing")
	if player.move_dir != Vector2i(0, 0):
		dash_direction = Vector2(player.move_dir).normalized()
	else: 
		if player.facing_right: dash_direction = Vector2(1,0)
		else: dash_direction = Vector2(-1, 0)
	player.can_dash = false
	player.dashed.emit()

func Update(_delta : float):
	if Input.is_action_just_pressed("dash") and player.can_dash:
		Transitioned.emit(self, "dashing")
	if Input.is_action_just_pressed("jump") and player.can_jump:
		Transitioned.emit(self, "on air")

func Physics_Update(_delta : float):
	dash_timer -= _delta
	if dash_timer > 0: 
		player.velocity = player.dash_speed * dash_direction
	else:
		if player.is_on_floor():
			player.velocity.x = move_toward(player.velocity.x, 0, 900 * _delta)
			if player.velocity.x == 0: Transitioned.emit(self, "idle")
		else:
			Transitioned.emit(self, "on air")
	
