extends Node
class_name DecayingPlatformParent

var decaying_platforms = []
@export var decaying_time : float = 2.5

func _ready() -> void:
	for child in get_children():
		if child is DecayingPlatform:
			decaying_platforms.append(child)

func start_platforms_decay():
	for platform : DecayingPlatform in decaying_platforms:
		platform.start_decay(decaying_time)
