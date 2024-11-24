extends Node2D
class_name RotatingObstacle

@export var radius : int = 20
@export var rotation_velocity : float = 1

@export var child_obstacle : Node2D
@export var starting_position : Vector2 = Vector2(1, 0)

func _ready() -> void:
	child_obstacle.position = starting_position.normalized() * radius

func _physics_process(delta: float) -> void:
	rotation += rotation_velocity * delta
