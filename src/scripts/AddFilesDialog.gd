class_name AddFilesDialog extends FileDialog


var current_files_selected : PackedStringArray


func _ready():
	pass


func _on_files_selected(paths):
	current_files_selected = paths
