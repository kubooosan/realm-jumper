class_name DimensionComponent
extends Node
var parent_node : Node2D

@export var dimension_origin : int 
var object_is_active : bool

func _enter_tree() -> void:
	if get_parent():
		parent_node = get_parent()
	if dimension_origin == GameManager.active_dimension: enable_object()
	else: disable_object()
	GameManager.jumped_dimensions.connect(jumped_to_dimension)

func jumped_to_dimension(target_dimension : int):
	if target_dimension == dimension_origin:
		enable_object()
	else: disable_object()

func enable_object():
	if parent_node: parent_node.visible = true
	object_is_active = true

func disable_object():
	if parent_node: parent_node.visible = false
	object_is_active = false
