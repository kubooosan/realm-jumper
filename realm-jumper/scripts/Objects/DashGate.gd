class_name DashGate
extends Sprite2D

@onready var static_body: StaticBody2D = $StaticBody2D
@export var dimension_component : DimensionComponent
var player : Player

var is_down : bool : set = toggled_gate

const DASHGATE_DOWN = preload("res://assets/dashgate_temp.png")
const DASHGATE_UP = preload("res://assets/dashgate_up_temp.png")

func _ready() -> void:
	player = get_node("../Player")
	player.dashed.connect(toggle_gate)
	is_down = true
	
func toggle_gate():
	is_down = not is_down

func toggled_gate(new_value):
	if new_value == true:
		texture = DASHGATE_DOWN
		static_body.collision_layer = dimension_component.dimension_origin + 1
	elif new_value == false:
		texture = DASHGATE_UP
		static_body.collision_layer = 0
	is_down = new_value
	print(static_body.collision_layer)
