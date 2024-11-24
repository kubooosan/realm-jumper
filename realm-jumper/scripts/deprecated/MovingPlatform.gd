class_name MovingPlatform
extends AnimatableBody2D

@export var period : float = 2.5
@export var point_1 : Node2D
@export var point_2 : Node2D
var target_point : Node2D
@export var dimension_component : DimensionComponent

func _ready() -> void:
	global_position = point_1.global_position
	target_point = point_2

func _physics_process(delta: float) -> void:
	if dimension_component.object_is_active:
		global_position = global_position.move_toward(target_point.global_position, (point_1.global_position.distance_to(point_2.global_position)/period) * delta)
	if global_position == point_1.global_position:
		target_point = point_2
	elif global_position == point_2.global_position:
		target_point = point_1
