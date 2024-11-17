class_name MainCamera
extends Camera2D

@export_enum("Follow Player:0") var behaviour : int
var player : Player

func _enter_tree() -> void:
	player = get_parent().get_node("Player")

func _process(delta: float) -> void:
	# follow player
	if behaviour == 0:
		global_position = player.global_position
	pass
