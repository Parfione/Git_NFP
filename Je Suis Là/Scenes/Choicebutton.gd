extends Button

signal link_to(link)

var links:Array
var condition


@onready var label = %Label

func init(choice:String, in_links:String, in_condition:String = ""):
	label.text = choice
	links =  Array(in_links.split("|"))
	condition = in_condition
	

func pick_link():
	#CHECK CONDITION
	return links.pick_random()


func _on_button_up():
	link_to.emit(pick_link(),label.text)
	
