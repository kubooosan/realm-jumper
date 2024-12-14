extends AnimatedSprite2D
class_name InteractableLore

@export_multiline var texts : Array[String]
@onready var prompt: Sprite2D = $Prompt

var visible_timer : float

#func _process(delta: float) -> void:
	#if visible_timer > 0: visible_timer -= delta
	#else: prompt.visible = false

func toggle_interact_prompt(turn_on : bool):
	prompt.visible = turn_on
	if turn_on:
		visible_timer = .5
	
