extends State
class_name PlayerOnWall

var player : Player
var distance_to_wall

func Enter():
	player = get_node("../..")
	distance_to_wall = Vector2(player.global_position - player.wall_cast.get_collision_point()).x
	player.global_position.x -= distance_to_wall
	player.velocity = Vector2(0, 0)
	player.can_jump = true
	player.can_dash = true

func Update(_delta : float):
	if not player.is_on_floor():
		# pressed opposite key
		if player.move_dir.x * distance_to_wall > 0:
			player.velocity.x = player.move_dir.x * 75
			Transitioned.emit(self, "on air")
		# wall jump
		if Input.is_action_just_pressed("jump"):
			player.flip_player(true)
			player.jumping_from_wall = true
			player.velocity.x = 250
			Transitioned.emit(self, "on air")
		if player.is_on_floor():
			Transitioned.emit(self, "idle")
		else:
			if player.wall_cast.enabled and not player.wall_cast.is_colliding():
				Transitioned.emit(self, "on air")

func Physics_Update(_delta : float):
	player.velocity.y += player.get_gravity().y * 0.2 * _delta
