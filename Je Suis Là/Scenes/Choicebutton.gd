extends Button

signal link_to(link)

var links:Array
var condition


@onready var label = %Label
@onready var panel_bg = %PanelBG

func get_label_text():
	return label.text

func init(choice:String, in_links:String, in_condition:String = ""):
	label.text = choice
	links =  Array(in_links.split("|"))
	condition = in_condition
	await get_tree().create_timer(0.01).timeout
	size = label.size*1.1
	panel_bg.size = label.size
	

func set_colors(bg_mod,front_mod):
	panel_bg.modulate = bg_mod
	label.modulate = front_mod

func pick_link():
	#CHECK CONDITION
	return links.pick_random()


func _on_button_up():
	link_to.emit(pick_link(),label.text)
