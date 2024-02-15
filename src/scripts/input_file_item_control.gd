class_name InputFileItemControl extends Control


@onready var file_label : Label = find_child("InputFileItemLabel")


func _ready():
	pass

func set_label(_text : String):
	file_label.text = _text

func _on_eliminate_button_button_up():
	GlobalLinks.main_menu_control.remove_input_file(file_label.text)
	queue_free()
