class_name Player
extends CharacterBody2D

@export var sprite: Sprite2D
@export var wall_raycast: RayCast2D

var max_move_velocity : float = 200
var air_acceleration : float = 450

var jump_velocity = -200.0
@export var max_jump_timer : float = .18
var can_jump : bool
var jump_timer : float
var is_jumping : bool

var is_wall_jumping : bool
var wall_jump_dir : Vector2
var wall_jump_velocity : float = 150
var max_wall_jump_timer : float = .2
var wall_jump_timer : float

var can_dash : bool = true
var dash_speed : float = 350
var dash_dir : Vector2
var is_dashing : bool
var max_dash_timer : float = .15
var dash_timer : float

var dimension_jump_count : int
var dimension_jump_max : int = 2
var facing_left : bool

func _ready() -> void:
	GameManager.jumped_dimensions.connect(jumped_to_dimension)

func _process(delta: float) -> void:
	var direction_x := Input.get_axis("left", "right")
	var direction_y := Input.get_axis("up", "down")
	dash_timer += delta
	wall_jump_timer += delta
	if is_dashing:
		if dash_timer <= max_dash_timer:
			velocity.x = dash_dir.x * dash_speed
			velocity.y = dash_dir.y * dash_speed
		else: 
			is_dashing = false
	elif is_wall_jumping:
		print(wall_jump_dir)
		if wall_jump_timer <= max_wall_jump_timer:
			velocity.x = wall_jump_dir.x * wall_jump_velocity
			velocity.y = wall_jump_dir.y * wall_jump_velocity
		else: 
			is_wall_jumping = false
	else:
		var is_on_wall : bool = wall_raycast.is_colliding() and not is_on_floor()
		var distance_to_wall : float
		print("not dashing nor wall jumping")
		# Wall Logic
		if is_on_wall and not is_wall_jumping:
			distance_to_wall = Vector2(global_position - wall_raycast.get_collision_point()).x
			if distance_to_wall > 0:
				global_position.x = global_position.move_toward(wall_raycast.get_collision_point(), 12).x + 7
			elif distance_to_wall < 0:
				global_position.x = global_position.move_toward(wall_raycast.get_collision_point(), 12).x - 7
		
		if is_on_floor():
			reset_stamina()
		elif not is_on_floor():
			if is_on_wall:
				if velocity.y >= 0: velocity += get_gravity() * delta * .4
				else: velocity.y = 0
			elif !is_on_wall:
				if velocity.y >= -3: velocity += get_gravity() * delta * 1.2
				else: velocity += get_gravity() * delta
		
		# Direction handling
		if direction_x:
			if is_on_floor():
				velocity.x = direction_x * max_move_velocity
			else: 
				if abs(velocity.x + direction_x * air_acceleration * delta) < max_move_velocity:
					velocity.x += direction_x * air_acceleration * delta
		else:
			velocity.x = move_toward(velocity.x, 0, 100)
		
		# Jump handling
		if Input.is_action_just_pressed("jump"):
			if !is_on_wall:
				if can_jump:
					is_jumping = true
					can_jump = false
			elif is_on_wall:
				flip_player()
				if facing_left:
					wall_jump_dir = Vector2(-sqrt(2), -sqrt(2))
				else:
					wall_jump_dir = Vector2(sqrt(2), -sqrt(2))
				is_wall_jumping = true
				wall_jump_timer = 0
		elif Input.is_action_just_released("jump"):
			is_jumping = false

		if is_jumping and jump_timer < max_jump_timer:
			velocity.y = jump_velocity
			jump_timer += delta

		# Dash Handling
		if Input.is_action_just_pressed("dash") and can_dash:
			is_jumping = false
			can_dash = false
			is_dashing = true
			dash_timer = 0
			if direction_x == 0 and direction_y == 0:
				if facing_left: dash_dir = Vector2(-1, 0)
				else: dash_dir = Vector2(1, 0)
			else: dash_dir = Vector2(direction_x, direction_y).normalized()
			
		if Input.is_action_just_pressed("dimension jump") and (dimension_jump_count < dimension_jump_max):
			GameManager.switch_dimensions()
			dimension_jump_count += 1

	move_and_slide()
	
	# Sprite flipping
	if direction_x != 0: flip_player(direction_x)

func reset_stamina():
	can_dash = true
	can_jump = true
	dimension_jump_count = 0
	is_jumping = false
	jump_timer = 0

func jumped_to_dimension(target_dimension : int):
	collision_layer = target_dimension + 1
	collision_mask = target_dimension + 1
	wall_raycast.collision_mask = target_dimension + 1
	print(collision_layer, collision_mask)

func flip_player(direction : int = 0):
	if direction == 1:
		facing_left = false
		sprite.flip_h = false
		wall_raycast.target_position.x = 12
	elif direction == -1:
		facing_left = true
		sprite.flip_h = true
		wall_raycast.target_position.x = -12
	else: # flip to opposite direction
		if facing_left:
			facing_left = false
			sprite.flip_h = false
			wall_raycast.target_position.x = 12
		else:
			facing_left = true
			sprite.flip_h = true
			wall_raycast.target_position.x = -12
