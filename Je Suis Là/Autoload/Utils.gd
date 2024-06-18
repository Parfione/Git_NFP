extends Node

const IMAGES_FOLDER = "res://images/"
const FORBIDDEN_ICON = preload("res://images/forbiddenIcon.png")

func load_img(name:String):
	var img_path = IMAGES_FOLDER + name + ".jpg"
	if FileAccess.file_exists(img_path):
		return load(img_path)
	
	img_path = IMAGES_FOLDER + name + ".png"
	if FileAccess.file_exists(img_path):
		return load(img_path)
	
	return FORBIDDEN_ICON


func load_JSON(path:String):
	if !FileAccess.file_exists(path): return {}
	
	var file = FileAccess.get_file_as_string(path)
	return JSON.parse_string(file)
