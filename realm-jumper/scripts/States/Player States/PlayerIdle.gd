extends State
class_name PlayerIdle

var player : Player

func Enter():
	player = get_node("../..")
	player.reset_stamina()
	if not player.is_on_floor(): 
		Transitioned.emit(self, "on air")
	else:
		player.velocity.x = 0

func Update(_delta : float):
	if not player.is_on_floor(): 
		Transitioned.emit(self, "on air")
	elif player.is_on_floor() and player.can_jump and Input.is_action_just_pressed("jump"): 
		Transitioned.emit(self, "on air")
	
	if Input.is_action_just_pressed("dash") and player.can_dash:
		Transitioned.emit(self, "dashing")
	elif player.move_dir.x != 0: 
		Transitioned.emit(self, "grounded strafe")
