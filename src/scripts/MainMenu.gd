class_name MainMenu extends Control



func _ready():
	pass


func open_add_files_interface():
	%AddFilesDialog.popup_centered()


func _process(_delta):
	pass


func _on_exit_button_button_up():
	get_tree().quit()

func _on_add_files_button_button_up():
	open_add_files_interface()
