class_name DimensionBlock
extends Sprite2D
@export var dimension_component : DimensionComponent
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and dimension_component.object_is_active:
		var player : Player = body
		GameManager.switch_dimensions()
		if player.velocity.y > 0.05: player.velocity.y = -.5 * player.velocity.y
		player.reset_stamina(true, false)
