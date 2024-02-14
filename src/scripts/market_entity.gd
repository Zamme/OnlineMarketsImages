class_name MarketEntity


var _Name
var _ID : int
var _Images : Array


func _init(_name : String = "", _id : int = -1, _params : Array = Array()):
	_Name = _name
	_ID = _id
	_Images = Array()
	set_images(_params)

func set_images(_params : Array):
	for _par in _params:
		var _new_image_entity : ImageEntity = ImageEntity.new(_par.ImageID, _par.SizeA, _par.SizeB)
		_Images.append(_new_image_entity)
