extends Sprite2D
class_name BackgroundTorch
@onready var light: PointLight2D = $Light

func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.is_in_group("Light"):
		light.visible = true
