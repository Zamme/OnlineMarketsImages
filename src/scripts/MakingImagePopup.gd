class_name MakingImagePopup extends Popup


@onready var current_image_name_label : Label = find_child("CurrentImageProcessedNameLabel")
@onready var total_process_progressbar : ProgressBar = find_child("TotalProcessProgressBar")


func _ready():
	pass

func reset_values():
	current_image_name_label.text = ""
	total_process_progressbar.value = 0

func set_image_name(_im_name : String):
	current_image_name_label.text = _im_name

func set_process_value(_value : int):
	total_process_progressbar.value = _value
