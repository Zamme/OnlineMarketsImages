class_name MainMenu extends Control


const JSONS_DIRPATH = "res://assets/jsons/"
const APPSTORE_JSON_FILENAME = "OMI_Stores_Sizes - AppStore.json"
const PLAYSTORE_JSON_FILENAME = "OMI_Stores_Sizes - PlayStore.json"

@onready var add_files_dialog : FileDialog = find_child("AddFilesDialog")
@onready var dest_files_dialog : FileDialog = find_child("DestFileDialog")
@onready var files_item_list : ItemList = find_child("FilesItemList")
@onready var store_info_vbox : VBoxContainer = find_child("StoreInfoVBoxContainer")
@onready var dest_path_label : Label = find_child("DestPathLabel")
@onready var store_options_hbox : HBoxContainer = find_child("StoreOptionsHBoxContainer")

var markets : Array

var current_files_selected : PackedStringArray
var store_info_button_prefab : PackedScene = load("res://src/store_info_button.tscn")
var current_store_id_selected : int = -1
var current_dest_path : String = ""


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

func open_add_files_interface():
	add_files_dialog.popup_centered()

func open_dest_file_dialog():
	dest_files_dialog.popup_centered()

func set_files_selected(_paths):
	current_files_selected = _paths
	update_files_item_list()
	#print("Files Selected:")
	#print(current_files_selected)

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

