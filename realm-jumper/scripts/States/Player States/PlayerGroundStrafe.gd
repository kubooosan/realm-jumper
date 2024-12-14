extends State
class_name PlayerGroundStrafe

var player : Player

var step_sfx_array = [preload("res://audio/sfx/walking1.mp3"), preload("res://audio/sfx/walking2.mp3"), preload("res://audio/sfx/walking3.mp3")]

var coyote_timer = 0
var max_coyote_timer = .13

func Enter():
	player = get_node("../..")
	if player.is_on_floor(): player.reset_stamina()
	player.anim_player.play("running")

func Update(_delta : float):
	if !player.audio_player.playing:
		player.audio_player.pitch_scale = 1
		player.audio_player.volume_db = randf_range(-2, 2)
		player.audio_player.stream = (step_sfx_array[randi() % step_sfx_array.size()])
		player.audio_player.play()
	# Input Handling
	if Input.is_action_just_pressed("jump"):
		Transitioned.emit(self, "on air")
	if Input.is_action_just_pressed("dash") and player.can_dash:
		Transitioned.emit(self, "dashing")
	
	if not player.is_on_floor():
		coyote_timer += _delta
		if coyote_timer > max_coyote_timer:
			Transitioned.emit(self, "on air")
	elif player.velocity.x == 0:
		Transitioned.emit(self, "idle")
	else: coyote_timer = 0
	
	player.velocity.x = player.move_dir.x * player.move_speed
		
