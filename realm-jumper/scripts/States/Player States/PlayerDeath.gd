extends State
class_name PlayerDeath

var player : Player

func Enter():
	player = get_node("../..")
	player.velocity = Vector2(0, 0)
