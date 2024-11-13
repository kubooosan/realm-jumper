extends Node
var active_dimension : int : set = switch_dimensions
signal jumped_dimensions(target_dimension)

func switch_dimensions(target_dimension : int = -1):
	if target_dimension == -1: target_dimension = get_inactive_dimension()
	active_dimension = target_dimension
	jumped_dimensions.emit(target_dimension)

func get_inactive_dimension() -> int:
	match active_dimension:
		0: return 1
		1: return 0
	return 0
