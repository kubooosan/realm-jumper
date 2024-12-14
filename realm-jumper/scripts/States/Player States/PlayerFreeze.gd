extends State
class_name PlayerFreeze

var player : Player

func Enter():
	print("awdjawdawfhbashdbjhb")
	player = get_node("../..")
	player.velocity = Vector2(0, 0)

func Exit():
	Transitioned.emit(self, "idle")
