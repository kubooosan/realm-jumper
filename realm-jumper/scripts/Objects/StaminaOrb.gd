extends Sprite2D
class_name StaminaOrb

var is_collectable : bool = true : set = set_collectable

@export var cooldown_time : float = 2.5
var cooldown_timer : float

const STAMINA_ORB = preload("res://assets/stamina_orb.png")
const STAMINA_ORB_EMPTY = preload("res://assets/stamina_orb_empty.png")

var time : float
func _process(delta: float) -> void:
	cooldown_timer -= delta
	if cooldown_timer <= 0 and is_collectable == false:
		is_collectable = true
	pass

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("Player") and is_collectable:
		var player : Player = body
		if player.can_dash: return
		print(self, "collected")
		is_collectable = false
		player.reset_stamina(true, false)
		collected()

func collected():
	is_collectable = false
	cooldown_timer = cooldown_time

func set_collectable(new_value):
	if new_value == true:
		is_collectable = true
		texture = STAMINA_ORB
	elif new_value == false:
		is_collectable = false
		texture = STAMINA_ORB_EMPTY
