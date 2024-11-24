extends Area2D
class_name RespawnPointArea

@onready var child_respawn_point: Sprite2D = $RespawnPoint

@export var respawn_facing_right : bool

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		GameManager.active_respawn_point_coordinate = child_respawn_point.global_position
		GameManager.respawn_facing_right = respawn_facing_right
