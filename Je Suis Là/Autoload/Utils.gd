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
