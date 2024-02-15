class_name MainMenu extends Control


const JSONS_DIRPATH = "res://assets/jsons/"
const APPSTORE_JSON_FILENAME = "OMI_Stores_Sizes - AppStore.json"
const PLAYSTORE_JSON_FILENAME = "OMI_Stores_Sizes - PlayStore.json"
const DEFAULT_PREFIX = "OMI_Image_"

@onready var add_files_dialog : FileDialog = find_child("AddFilesDialog")
@onready var dest_files_dialog : FileDialog = find_child("DestFileDialog")
@onready var files_item_list : ItemList = find_child("FilesItemList")
@onready var store_info_vbox : VBoxContainer = find_child("StoreInfoVBoxContainer")
@onready var dest_path_label : Label = find_child("DestPathLabel")
@onready var store_options_hbox : HBoxContainer = find_child("StoreOptionsHBoxContainer")
@onready var incorrect_accept_dialog : AcceptDialog = find_child("IncorrectAcceptDialog")
@onready var prefix_line_edit : LineEdit = find_child("PrefixLineEdit")

var markets : Array

var current_files_selected : PackedStringArray
var store_info_button_prefab : PackedScene = load("res://src/store_info_button.tscn")
var current_store_id_selected : int = -1
var current_dest_path : String = ""
var current_store_images_type_selected : Array = Array()


func _ready():
	GlobalLinks.main_menu_control = self
	get_markets()
	update_files_item_list()
	update_store_options_hbox()

func clear_files_item_list():
	files_item_list.clear()

func get_markets():
	markets = Array()
	var json_result = SJ_UTILS.read_json(JSONS_DIRPATH + APPSTORE_JSON_FILENAME)
	var market_entity : MarketEntity = MarketEntity.new("AppStore", 0, json_result)
	markets.append(market_entity)
	json_result = SJ_UTILS.read_json(JSONS_DIRPATH + PLAYSTORE_JSON_FILENAME)
	market_entity = MarketEntity.new("PlayStore", 1, json_result)
	markets.append(market_entity)
	#print(markets)

func is_dest_correct():
	var _is_correct : bool = true
	var dir = DirAccess.open(current_dest_path)
	if dir:
		var _files : PackedStringArray = dir.get_files()
		if _files.is_empty():
			pass
		else:
			_is_correct = false
	else:
		print("An error occurred when trying to access the path.")
		_is_correct = false	
	return _is_correct

func is_input_files_correct():
	return !current_files_selected.is_empty()

func is_store_correct():
	return (current_store_id_selected > -1)

func make_images():
	print("Making images...")
	

func open_add_files_interface():
	add_files_dialog.popup_centered()

func open_dest_file_dialog():
	dest_files_dialog.popup_centered()

func set_files_selected(_paths):
	current_files_selected = _paths
	update_files_item_list()
	#print("Files Selected:")
	#print(current_files_selected)

func show_incorrect_dialog(_message : String):
	incorrect_accept_dialog.dialog_text = _message
	incorrect_accept_dialog.popup_centered()

func update_dest_path_label():
	dest_path_label.text = current_dest_path

func update_files_item_list():
	clear_files_item_list()
	for it in current_files_selected:
		files_item_list.add_item(it)

func update_store_info():
	for lab in store_info_vbox.get_children():
		store_info_vbox.remove_child(lab)
		lab.queue_free()
	var current_market = markets[current_store_id_selected]
	for _image in current_market._Images:
		var new_line : Button = store_info_button_prefab.instantiate()
		new_line.text = str(_image._SizeA) + " x " + str(_image._SizeB)
		store_info_vbox.add_child(new_line)
	update_store_options_hbox()

func update_store_options_hbox():
	store_options_hbox.visible = (current_store_id_selected > -1)

func _process(_delta):
	pass

func _on_exit_button_button_up():
	get_tree().quit()

func _on_add_files_button_button_up():
	open_add_files_interface()

func _on_play_store_menu_button_toggled(toggled_on):
	if toggled_on:
		current_store_id_selected = 1
		update_store_info()

func _on_app_store_menu_button_toggled(toggled_on):
	if toggled_on:
		current_store_id_selected = 0
		update_store_info()

func _on_select_destination_button_button_up():
	open_dest_file_dialog()

func _on_dest_file_dialog_dir_selected(dir):
	current_dest_path = dir
	update_dest_path_label()

func _on_all_button_button_up():
	for _info_button in store_info_vbox.get_children():
		_info_button.button_pressed = true

func _on_none_button_button_up():
	for _info_button in store_info_vbox.get_children():
		_info_button.button_pressed = false

func _on_make_images_button_button_up():
	if is_dest_correct():
		if is_input_files_correct():
			if is_store_correct():
				make_images()
			else:
				show_incorrect_dialog("No Store Images selected")
		else:
			show_incorrect_dialog("No Input files selected")
	else:
		show_incorrect_dialog("Dest folder not selected or not empty")
