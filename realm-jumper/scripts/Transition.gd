extends TextureRect
class_name Transition

signal finished_transition

func _ready() -> void:
	GameManager.transitioned_scenes.connect(on_instantiate)

func on_instantiate(to : bool):
	#get_parent().print_tree_pretty()
	var tween = create_tween()
	if to:
		scale = Vector2(0.1, 0.1)
		tween.tween_property(self, "scale", Vector2(1.1, 1.1), .35).set_ease(Tween.EASE_OUT)
	else:
		scale = Vector2(1.1, 1.1)
		tween.tween_property(self, "scale", Vector2(0, 0), .35).set_ease(Tween.EASE_OUT)
		tween.tween_callback(queue_free)
	tween.tween_callback(finished_transition.emit)
