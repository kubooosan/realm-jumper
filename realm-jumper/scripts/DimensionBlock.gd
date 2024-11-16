class_name DimensionBlock
extends Sprite2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("player entered")
		var player : Player = body
		GameManager.switch_dimensions()
		player.reset_stamina(true, false)
