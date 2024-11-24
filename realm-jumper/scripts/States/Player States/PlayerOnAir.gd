extends State
class_name PlayerOnAir

var player : Player

var jump_timer : float
var max_jump_timer : float = .16

var is_jumping : bool

var initial_velocity : Vector2
var max_air_velocity = Vector2(350, 850)

func Enter():
	player = get_node("../..")
	# Entered on air because of jumping
	if player.can_jump and Input.is_action_pressed("jump"):
		initial_velocity = player.velocity
		player.can_jump = false
		jump_timer = max_jump_timer
		is_jumping = true
	# Entered on air because of falling
	else: is_jumping = false

func Update(_delta : float):
	if is_jumping and Input.is_action_pressed("jump"):
		jump_timer -= _delta
		if jump_timer > 0:
			player.velocity.y = -player.jump_speed
	elif player.is_on_floor(): 
		Transitioned.emit(self, "idle")

	if Input.is_action_just_released("jump"): 
		is_jumping = false

func Physics_Update(_delta : float):
	# Gravity is bigger when falling
	if player.velocity.y > 0:
		player.velocity += player.get_gravity() * _delta
	else:
		player.velocity += player.get_gravity() * _delta * 1.2
	
	# Air drag
	print(player.move_dir.x * initial_velocity.x < 0)
	if player.move_dir.x == 0 and not player.jumping_from_wall: 
		player.velocity.x = move_toward(player.velocity.x, 0, 700 * _delta)
	
	# Move to opposite direction
	if player.move_dir.x * initial_velocity.x < 0:
		if player.velocity.x * initial_velocity.x > 0:
			player.velocity.x = move_toward(player.velocity.x, -3, 800 * _delta)
		else:
			player.velocity.x += player.move_dir.x * player.move_speed * _delta
	else:
		player.velocity.x += player.move_dir.x * player.move_speed * 0.8 * _delta
	
	player.velocity.x = clampf(player.velocity.x, -max_air_velocity.x, max_air_velocity.x)
	player.velocity.y = clampf(player.velocity.y, -max_air_velocity.y, max_air_velocity.y)
	
	# Wall check
	if player.wall_cast.is_colliding(): Transitioned.emit(self, "on wall")
	
	# Input Handling
	if Input.is_action_just_pressed("dash") and player.can_dash:
		Transitioned.emit(self, "dashing")
