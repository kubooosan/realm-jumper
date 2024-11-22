extends RichTextLabel
@export var player : Player

func _process(delta: float) -> void:
	if player.state_machine and player.state_machine.current_state:
		text = ("move dir: {dir}\ncan_dash: {can_dash}\nstate: {state}\nvelocity: {vel}".format({"dir":player.move_dir, "can_dash":player.can_dash, "state":player.state_machine.current_state.name, "vel":player.velocity}))
