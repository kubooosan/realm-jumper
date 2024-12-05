extends State
class_name PlayerOnAir

var player : Player

var jump_timer : float
var max_jump_timer : float = .16

var is_jumping : bool

var initial_velocity : Vector2
var max_air_velocity = Vector2(200, 850)

var lock_movement_timer : float

func Enter():
	player = get_node("../..")
	player.anim_player.play("on_air")
	# Entered because of wall jumping
	if player.jumping_from_wall:
		lock_movement_timer = .2
	# Entered on air because of jumping
	if player.can_jump and Input.is_action_pressed("jump"):
		initial_velocity = player.velocity
		player.can_jump = false
		jump_timer = max_jump_timer
		is_jumping = true
	# Entered on air because of falling
	else: is_jumping = false

func Update(_delta : float):
	if lock_movement_timer > 0: 
		lock_movement_timer -= _delta
	# Input Handling
	if Input.is_action_just_released("jump"): 
		is_jumping = false
	if Input.is_action_just_pressed("dash") and player.can_dash:
		Transitioned.emit(self, "dashing")
	if is_jumping and Input.is_action_pressed("jump"):
		jump_timer -= _delta
		if jump_timer > 0:
			player.velocity.y = -player.jump_speed
	if player.is_on_floor(): 
		Transitioned.emit(self, "idle")

func Physics_Update(_delta : float):
	# Gravity is bigger when falling
	if player.velocity.y > 0:
		player.velocity += player.get_gravity() * _delta
	else:
		player.velocity += player.get_gravity() * _delta * 1.2
	
	# Air drag
	if player.move_dir.x == 0 and not player.jumping_from_wall: 
		player.velocity.x = move_toward(player.velocity.x, 0, 700 * _delta)

	if player.move_dir.x != 0 and lock_movement_timer <= 0:
		player.velocity.x += player.move_dir.x * player.move_speed * _delta * 6
	
	player.velocity.x = clampf(player.velocity.x, -max_air_velocity.x, max_air_velocity.x)
	player.velocity.y = clampf(player.velocity.y, -max_air_velocity.y, max_air_velocity.y)

	# Wall check 
	if player.wall_cast.is_colliding() and not player.wall_cast.get_collider().is_in_group("Death") and lock_movement_timer <= 0: 
		Transitioned.emit(self, "on wall")
	
	
