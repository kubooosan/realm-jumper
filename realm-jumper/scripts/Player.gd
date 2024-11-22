class_name Player
extends CharacterBody2D

var state_machine : StateMachine

var move_dir : Vector2i
var move_speed : float = 200.0

var can_jump : bool
var jump_speed : float = 250

var can_dash : bool
var dash_speed : float = 300
var jumping_from_wall
var facing_right : bool = true

@onready var collision_area: Area2D = $"Collision Area"
@onready var wall_cast: RayCast2D = $"Wall Check"
@onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	state_machine = $StateMachine
	GameManager.jumped_dimensions.connect(jump_dimension)

func _process(delta: float) -> void:
	move_dir.x = Input.get_axis("left", "right")
	move_dir.y = Input.get_axis("up", "down")
	if move_dir.x == 1: 
		facing_right = true
		flip_player(true)
	elif move_dir.x == -1: 
		facing_right = false
		flip_player(false)
	move_and_slide()
	wall_cast.enabled = velocity.y > -0.001 and not is_on_floor()

func flip_player(to_right=true):
	sprite.flip_h = not to_right
	if to_right: wall_cast.target_position = Vector2i(12, 0)
	else: wall_cast.target_position = Vector2i(-12, 0)

func reset_stamina(reset_dash=true, reset_jump=true):
	if reset_dash: can_dash = true
	if reset_jump: can_jump = true
	jumping_from_wall = false

func jump_dimension(target_dimension):
	collision_layer = target_dimension + 1
	collision_mask = target_dimension + 1
	collision_area.collision_layer = target_dimension + 1
	collision_area.collision_mask = target_dimension + 1
	wall_cast.collision_mask = target_dimension + 1

func die():
	get_tree().reload_current_scene()
	pass

func _on_collision_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("Death"):
		die()
