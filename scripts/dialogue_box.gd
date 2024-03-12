class_name DialogueBox
extends Node2D

@onready var background_color : ColorRect = $Control/OuterMargin/BackgroundColor
@onready var dialogue_content : RichTextLabel = $Control/OuterMargin/InnerMargin/DialogueContent

var content_visible_tween : Tween
var is_typing : bool = false

func _ready() -> void:
	dialogue_content.text = ""

func play_content(content : String):
	dialogue_content.text = ""
	visible = true
	content_visible_tween = dialogue_content.create_tween()
	content_visible_tween.tween_callback(func(): is_typing = true)
	content_visible_tween.tween_property(dialogue_content, "visible_ratio", 0, 0)
	content_visible_tween.tween_callback(func(): dialogue_content.text = content)
	content_visible_tween.tween_property(dialogue_content, "visible_ratio", 1, 1)
	content_visible_tween.tween_callback(func(): is_typing = false)

func hide_content():
	visible = false
