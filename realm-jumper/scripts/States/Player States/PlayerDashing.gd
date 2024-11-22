extends State
class_name PlayerDashing

var dash_direction : Vector2
var dash_timer
@export var max_dash_timer = 0.1

var player : Player

func Enter():
	player = get_node("../..")
	dash_timer = max_dash_timer
	if player.move_dir != Vector2i(0, 0):
		dash_direction = Vector2(player.move_dir)
	else: 
		if player.facing_right: dash_direction = Vector2(1,0)
		else: dash_direction = Vector2(-1, 0)
	player.can_dash = false
	
func Physics_Update(_delta : float):
	dash_timer -= _delta
	if dash_timer > 0: player.velocity = player.dash_speed * dash_direction
	else:
		if player.is_on_floor():
			player.velocity.x = move_toward(player.velocity.x, 0, 750 * _delta)
			if player.velocity.x == 0: Transitioned.emit(self, "idle")
		else:
			Transitioned.emit(self, "on air")
	if player.is_on_floor() and Input.is_action_just_pressed("jump") and player.can_jump:
		Transitioned.emit(self, "on air")
