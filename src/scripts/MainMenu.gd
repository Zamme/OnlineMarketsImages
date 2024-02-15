class_name MainMenu extends Control


const JSONS_DIRPATH = "res://assets/jsons/"
const APPSTORE_JSON_FILENAME = "OMI_Stores_Sizes - AppStore.json"
const PLAYSTORE_JSON_FILENAME = "OMI_Stores_Sizes - PlayStore.json"
const DEFAULT_PREFIX = "OMI_Image_"

@onready var add_files_dialog : FileDialog = find_child("AddFilesDialog")
@onready var dest_files_dialog : FileDialog = find_child("DestFileDialog")
@onready var input_files_vbox : VBoxContainer = find_child("InputFilesVBox")
@onready var store_info_vbox : VBoxContainer = find_child("StoreInfoVBoxContainer")
@onready var dest_path_label : Label = find_child("DestPathLabel")
@onready var store_options_hbox : HBoxContainer = find_child("StoreOptionsHBoxContainer")
@onready var incorrect_accept_dialog : AcceptDialog = find_child("IncorrectAcceptDialog")
@onready var prefix_line_edit : LineEdit = find_child("PrefixLineEdit")
@onready var jpg_check : CheckBox = find_child("JPGCheckBox")
@onready var png_check : CheckBox = find_child("PNGCheckBox")
@onready var by_image_check : CheckBox = find_child("ByImageCheckBox")
@onready var by_resolution_check : CheckBox = find_child("ByResolutionCheckBox")
@onready var making_image_popup : MakingImagePopup = find_child("MakingImagePopup")

var store_info_button_prefab : PackedScene = load("res://src/store_info_button.tscn")
var input_file_item_control_prefab : PackedScene = load("res://src/input_file_item_control.tscn")

var markets : Array

var current_files_selected : PackedStringArray
var current_store_id_selected : int = -1
var current_dest_path : String = ""
var current_store_images_type_selected : Array = Array()


func _ready():
	GlobalLinks.main_menu_control = self
	get_markets()
	update_files_item_list()
	update_store_options_hbox()
	#test_01()

func add_files_selected(_paths):
	current_files_selected.append_array(_paths)
	update_files_item_list()

func add_image_size_pressed_button(_but_index : int):
	if current_store_images_type_selected.find(_but_index) < 0:
		current_store_images_type_selected.append(_but_index)

func clear_files_item_list():
	for _input_file in input_files_vbox.get_children():
		_input_file.queue_free()

func clear_files_list():
	current_files_selected.clear()

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
	var _is_correct : bool = true
	if current_store_images_type_selected.size() < 1:
		_is_correct = false
	elif current_store_id_selected < 0:
		_is_correct = false
	return _is_correct

func make_image(_source_image : Image, _image_entity : ImageEntity):
	var _image_created : Image = Image.new()
	print("Making image ", _image_entity._ID, " ", _image_entity._SizeA, "x", _image_entity._SizeB)
	_image_created.copy_from(_source_image)
	_image_created.resize(_image_entity._SizeA, _image_entity._SizeB, Image.INTERPOLATE_BILINEAR)
	return _image_created

func make_images_by_image():
	print("Making images...")
	#print(current_store_images_type_selected)
	making_image_popup.reset_values()
	making_image_popup.popup_centered()
	@warning_ignore("integer_division")
	var PER_IMAGE_VALUE : float = 100/(current_files_selected.size() * current_store_images_type_selected.size())
	var current_progress_value = 0
	var market_name : String = markets[current_store_id_selected]._Name
	for current_source in current_files_selected:
		var _current_source_name : String = current_source.get_file()
		var _n_parts : Array = _current_source_name.split(".")
		_current_source_name = _n_parts[0]
		var _source_image : Image = Image.load_from_file(current_source)
		var _new_dir_name : String = _current_source_name
		for current_image_size_index in current_store_images_type_selected:
			var _image_entity : ImageEntity = markets[current_store_id_selected]._Images[current_image_size_index]
			var new_image = make_image(_source_image, _image_entity)
			var _file_name : String = prefix_line_edit.text + str(_image_entity._SizeA) + "x" + str(_image_entity._SizeB)
			making_image_popup.set_image_name(_current_source_name + "_" + _file_name)
			if DirAccess.dir_exists_absolute(current_dest_path + "/" + market_name):
				pass
			else:
				DirAccess.make_dir_absolute(current_dest_path + "/" + market_name)
			if DirAccess.dir_exists_absolute(current_dest_path + "/" + market_name + "/" + _new_dir_name):
				pass
			else:
				DirAccess.make_dir_absolute(current_dest_path + "/" + market_name + "/" + _new_dir_name)
			var _dest_path : String = current_dest_path + "/" + market_name + "/" + _new_dir_name + "/" + _current_source_name + "_" + _file_name
			if jpg_check.button_pressed:
				_dest_path += ".jpg"
				new_image.save_jpg(_dest_path)
			else:
				_dest_path += ".png"
				new_image.save_png(_dest_path)
			current_progress_value += PER_IMAGE_VALUE
			making_image_popup.set_process_value(current_progress_value)
	making_image_popup.hide()

func make_images_by_resolution():
	print("Making images...")
	#print(current_store_images_type_selected)
	making_image_popup.reset_values()
	making_image_popup.popup_centered()
	@warning_ignore("integer_division")
	var PER_IMAGE_VALUE : float = 100/(current_files_selected.size() * current_store_images_type_selected.size())
	var current_progress_value = 0
	var market_name : String = markets[current_store_id_selected]._Name
	for current_source in current_files_selected:
		var _current_source_name : String = current_source.get_file()
		var _n_parts : Array = _current_source_name.split(".")
		_current_source_name = _n_parts[0]
		var _source_image : Image = Image.load_from_file(current_source)
		for current_image_size_index in current_store_images_type_selected:
			var _image_entity : ImageEntity = markets[current_store_id_selected]._Images[current_image_size_index]
			var new_image = make_image(_source_image, _image_entity)
			var _file_name : String = str(_image_entity._SizeA) + "x" + str(_image_entity._SizeB)
			var _new_dir_name : String = _file_name
			if DirAccess.dir_exists_absolute(current_dest_path + "/" + market_name):
				pass
			else:
				DirAccess.make_dir_absolute(current_dest_path + "/" + market_name)
			if DirAccess.dir_exists_absolute(current_dest_path + "/" + market_name + "/" + _new_dir_name):
				pass
			else:
				DirAccess.make_dir_absolute(current_dest_path + "/" + market_name + "/" + _new_dir_name)
			var _dest_path : String = current_dest_path + "/" + market_name + "/" + _new_dir_name + "/" + _current_source_name + "_" + _file_name
			if jpg_check.button_pressed:
				_dest_path += ".jpg"
				new_image.save_jpg(_dest_path)
			else:
				_dest_path += ".png"
				new_image.save_png(_dest_path)
			current_progress_value += PER_IMAGE_VALUE
			making_image_popup.set_process_value(current_progress_value)
	making_image_popup.hide()

func open_add_files_interface():
	add_files_dialog.popup_centered()

func open_dest_file_dialog():
	dest_files_dialog.popup_centered()

func remove_image_size_pressed_button(_but_index : int):
	var _found_pos : int = current_store_images_type_selected.find(_but_index)
	if _found_pos > -1:
		current_store_images_type_selected.remove_at(_found_pos)

func remove_input_file(_text : String):
	current_files_selected.remove_at(current_files_selected.find(_text))

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
		var _new_input_file : InputFileItemControl = input_file_item_control_prefab.instantiate()
		input_files_vbox.add_child(_new_input_file)
		_new_input_file.set_label(it)

func update_store_info():
	for lab in store_info_vbox.get_children():
		store_info_vbox.remove_child(lab)
		lab.queue_free()
	current_store_images_type_selected.clear()
	var current_market = markets[current_store_id_selected]
	for _image in current_market._Images:
		var new_line : StoreInfoButton = store_info_button_prefab.instantiate()
		new_line.text = str(_image._SizeA) + " x " + str(_image._SizeB)
		new_line.set_button_index(_image._ID)
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
		_info_button.set_button_pressed(true)

func _on_none_button_button_up():
	for _info_button in store_info_vbox.get_children():
		_info_button.set_button_pressed(false)

func _on_make_images_button_button_up():
	if is_dest_correct():
		if is_input_files_correct():
			if is_store_correct():
				if by_image_check.button_pressed:
					make_images_by_image()
				else:
					make_images_by_resolution()
			else:
				show_incorrect_dialog("No Store Images selected")
		else:
			show_incorrect_dialog("No Input files selected")
	else:
		show_incorrect_dialog("Dest folder not selected or not empty")

func _on_credits_rich_text_meta_clicked(meta):
	OS.shell_open(str(meta))

### TESTING ###
func test_01():
	_on_dest_file_dialog_dir_selected("/mnt/1704BF56620B1DF2/Google_Drive/Vilo_Studio/InDev_Apps/OnlineMarketImages/t1/")
	_on_app_store_menu_button_toggled(true)
	set_files_selected(["/mnt/1704BF56620B1DF2/Google_Drive/Vilo_Studio/InDev_Apps/OnlineMarketImages/PS_Shots/IMG_0285.PNG"])
	#current_dest_path = "/mnt/1704BF56620B1DF2/Google_Drive/Vilo_Studio/InDev_Apps/OnlineMarketImages/t1/"
	#current_files_selected = ["/mnt/1704BF56620B1DF2/Google_Drive/Vilo_Studio/InDev_Apps/OnlineMarketImages/PS_Shots/IMG_0285.PNG"]
	#current_store_id_selected = 0
	#current_store_images_type_selected = [0,1]
	#make_images()
