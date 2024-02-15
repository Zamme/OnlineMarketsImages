class_name AddFilesDialog extends FileDialog


func _ready():
	GlobalLinks.add_files_dialog = self

func _on_files_selected(paths):
	GlobalLinks.main_menu_control.add_files_selected(paths)
