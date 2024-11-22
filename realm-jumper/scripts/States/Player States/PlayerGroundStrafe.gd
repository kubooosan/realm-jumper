extends State
class_name PlayerGroundStrafe

var player : Player

func Enter():
	player = get_node("../..")
	if player.is_on_floor(): player.reset_stamina()

func Update(_delta : float):
	print("grounded: ", player.velocity.x)
	if not player.is_on_floor():
		Transitioned.emit(self, "on air")
	elif player.velocity.x == 0:
		Transitioned.emit(self, "idle")
	
	# Input Handling
	if Input.is_action_just_pressed("jump"):
		Transitioned.emit(self, "on air")
	if Input.is_action_just_pressed("dash") and player.can_dash:
		Transitioned.emit(self, "dashing")
	
	#if player.wall_cast.is_colliding():
		#Transitioned.emit(self, "on wall")
	
	player.velocity.x = player.move_dir.x * player.move_speed
		
