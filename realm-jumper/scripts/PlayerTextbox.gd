extends TextureRect
class_name PlayerTextbox

@onready var text_label: RichTextLabel = $Text
var player: Player

var texts : Array[String]
var active_text_index = 0
var in_lore : bool

func _input(event: InputEvent) -> void:
	if !in_lore: return
	if event is InputEventMouseButton:
		if event.button_mask and event.button_index == 1:
			advance_text()
	elif event.is_action_pressed("interact"):
		advance_text()

func _ready() -> void:
	player = $"../.."
var text_tween : Tween
func advance_text():
	if text_label.visible_ratio == 1:
		if active_text_index + 1 < len(texts): 
			active_text_index += 1
			text_label.text = texts[active_text_index]
			text_label.visible_ratio = 0
			text_tween = create_tween()
			text_tween.tween_property(text_label, "visible_ratio", 1, len(texts[active_text_index])/55)
		else:
			visible = false
	else:
		if text_tween: text_tween.kill()
		text_label.visible_ratio = 1

func start_lore(text_array):
	visible = true
	text_tween = create_tween()
	active_text_index = -1
	texts = text_array
	text_label.visible_ratio = 1
	in_lore = true
	advance_text()

func exit_lore():
	visible = false
	in_lore = false
	
	pass
