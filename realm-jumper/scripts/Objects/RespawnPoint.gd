extends Sprite2D
class_name RespawnPoint

@export var coordinate : Vector2
@export var facing_right : bool

func _ready() -> void:
	coordinate = global_position
