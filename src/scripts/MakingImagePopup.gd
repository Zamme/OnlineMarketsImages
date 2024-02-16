class_name MakingImagePopup extends Window


@onready var current_image_name_label : Label = find_child("CurrentImageProcessedNameLabel")
@onready var total_process_progressbar : ProgressBar = find_child("TotalProcessProgressBar")
@onready var cancel_button : Button = find_child("CancelButton")
@onready var view_button : Button = find_child("ViewFileManagerButton")
@onready var ok_button : Button = find_child("OkButton")


func _ready():
	pass

func reset_values():
	current_image_name_label.text = ""
	total_process_progressbar.value = 0

func set_image_name(_im_name : String):
	current_image_name_label.text = _im_name

func set_on_process(_on_process : bool):
	cancel_button.visible = _on_process
	view_button.visible = !_on_process
	ok_button.visible = !_on_process

func set_process_value(_value : int):
	total_process_progressbar.value = _value

func _on_cancel_button_button_up():
	GlobalLinks.main_menu_control.call_deferred("stop_making_images")

func _on_ok_button_button_up():
	hide()

func _on_view_file_manager_button_button_up():
	GlobalLinks.main_menu_control._on_open_file_manager_button_button_up()
	hide()
