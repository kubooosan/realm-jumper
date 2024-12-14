extends TextureRect
class_name CutsceneManager

@export var scenes : Array[Cutscene]
@export var next_scene : PackedScene
var active_scene_index : int = 0
var active_text_index : int
var active_scene : Cutscene
@onready var canvas_modulate: CanvasModulate = $"../CanvasModulate"
@onready var textbox: TextureRect = $"../Textbox"
@onready var text_label: RichTextLabel = $"../Textbox/RichTextLabel"

var text_tween : Tween

func _ready() -> void:
	active_scene = scenes[active_scene_index]
	text_tween = create_tween()
	text_tween.tween_property(canvas_modulate, "color", Color(1, 1, 1, 1), 1).set_ease(Tween.EASE_OUT)
	text_tween.tween_callback(toggle_textbox.bind(true)).set_delay(.75)
	text_label.text = active_scene.texts[0]
	text_label.visible_ratio = 0
	text_tween.tween_property(text_label, "visible_ratio", 1, 3)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_mask and event.button_index == 1:
			continue_scene()
	elif event.is_action_pressed("interact"):
		continue_scene()
#
#func _on_gui_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and textbox.visible: 
		#if event.button_mask and event.button_index == 1:
			#continue_scene()

func toggle_textbox(value : bool):
	textbox.visible = value

func continue_scene():
	if text_label.visible_ratio == 1:
		# Next Text
		if active_text_index + 1 < len(active_scene.texts):
			active_text_index += 1
			text_label.text = active_scene.texts[active_text_index]
			text_label.visible_ratio = 0
		# Next Scene
		elif active_scene_index + 1 < len(scenes):
			active_scene_index += 1
			active_text_index = 0
			text_label.visible_ratio = 0
			active_scene = scenes[active_scene_index]
			text_label.text = active_scene.texts[0]
			texture = active_scene.image
		# Transition to next scene
		else:
			GameManager.change_scene(next_scene)
		text_tween = create_tween()
		text_tween.tween_property(text_label, "visible_ratio", 1, len(active_scene.texts[active_text_index])/55)
	else:
		if text_tween: text_tween.kill()
		text_label.visible_ratio = 1
	print("active scene, text: ", active_scene_index, active_text_index)
