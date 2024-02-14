class_name SJ_UTILS extends Node


static func dir_contents(path):
	var files_list : Array = Array()
	var dir = DirAccess.open(path)
	if dir == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
#				print("Found directory: " + file_name)
			else:
#				print("Found file: " + file_name)
				if file_name.ends_with(".import"):
					pass
				else:
					files_list.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return files_list

static func read_json(path : String):
	var json_file = FileAccess.open(path, FileAccess.READ)
	var json_result
	var json_content = json_file.get_as_text()
	json_result = JSON.parse_string(json_content)
	json_file.close()
	return json_result

static func recursive_search_endswith(_node, _string : String):
	for _child in _node.get_children():
#		print(_child.name)
		if _child.name.ends_with(_string):
			return _child
		else:
			if _child.get_child_count() > 0:
				var found = recursive_search_endswith(_child, _string)
				if found != null:
					return found
