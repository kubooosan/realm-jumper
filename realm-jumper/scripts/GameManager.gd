extends Node
var active_dimension : int : set = switch_dimensions

signal jumped_dimensions(target_dimension)
signal transitioned_scenes(to : bool)

var active_respawn_point_coordinate : Vector2
var respawn_facing_right : bool

const TRANSITION = preload("res://scenes/transition.tscn")

func switch_dimensions(target_dimension : int = -1):
	if target_dimension == -1: target_dimension = get_inactive_dimension()
	active_dimension = target_dimension
	jumped_dimensions.emit(target_dimension)

func get_inactive_dimension() -> int:
	match active_dimension:
		0: return 1
		1: return 0
	return 0

func change_scene(packed_scene : PackedScene):
	var tween = create_tween()
	get_parent().add_child(TRANSITION.instantiate())
	tween.tween_callback(transitioned_scenes.emit.bind(true))
	tween.tween_callback(get_tree().change_scene_to_packed.bind(packed_scene)).set_delay(.7)
	tween.tween_callback(transitioned_scenes.emit.bind(false))
