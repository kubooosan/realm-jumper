extends StaticBody2D
class_name DecayingPlatform

var is_decaying : bool
var is_active : bool
var decay_timer : float
var regen_timer : float

@onready var sprite: Sprite2D = $Sprite
@export var dimension_component : DimensionComponent
@onready var parent : DecayingPlatformParent = $".."

const DECAYING_PLATFORM_INACTIVE = preload("res://assets/decaying_platform_inactive.png")
const DECAYING_PLATFORM = preload("res://assets/decaying_platform.png")

func _process(delta: float) -> void:
	if is_decaying:
		decay_timer -= delta
		if decay_timer <= 0:
			decayed()
	if regen_timer >= 0: 
		regen_timer -= delta
		if regen_timer <= 0:
			enable_platform()

func start_decay(decay_time: float):
	decay_timer = decay_time
	is_decaying = true
	
func decayed():
	is_decaying = false
	print("platform decayed")
	regen_timer = 2.5
	disable_platform()
	
func disable_platform():
	is_active = false
	sprite.texture = DECAYING_PLATFORM_INACTIVE
	collision_layer = 0
	collision_mask = 0
	
func enable_platform():
	is_active = true
	sprite.texture = DECAYING_PLATFORM
	collision_layer = dimension_component.dimension_origin + 1
	collision_mask = dimension_component.dimension_origin + 1

func _on_area_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.is_in_group("Player") and is_active and !is_decaying:
		parent.start_platforms_decay()
