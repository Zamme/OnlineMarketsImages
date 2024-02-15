class_name StoreInfoButton extends Button


var but_index : int = -1


func _ready():
	pass

func set_button_index(_index : int):
	but_index = _index

func set_button_pressed(_pressed : bool):
	button_pressed = _pressed
	if _pressed:
		GlobalLinks.main_menu_control.add_image_size_pressed_button(but_index)
	else:
		GlobalLinks.main_menu_control.remove_image_size_pressed_button(but_index)

func _on_toggled(toggled_on):
	if toggled_on:
		GlobalLinks.main_menu_control.add_image_size_pressed_button(but_index)
	else:
		GlobalLinks.main_menu_control.remove_image_size_pressed_button(but_index)

