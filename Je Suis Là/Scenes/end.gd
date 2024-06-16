extends Control


signal new_run 

const FACT_ITEM_SCENE = preload("res://fact_item.tscn")

@onready var fact_container = %FactContainer
@onready var end_sentence = %End_Sentence
@onready var image = %Image

func create_fact(ID,fact_data):
	var item = FACT_ITEM_SCENE.instantiate()
	fact_container.add_child(item)
	item.init(fact_data[ID]["Fact"],fact_data[ID]["Lien"])
	

func init(sentence:String,data,fact_data):
	end_sentence.text = sentence
	var fact_array = Array("F1,F2,F3".split(","))#remplacer "F1,F2,F3" par data["Facts"]
	for fact in fact_array:
		create_fact(fact,fact_data)
	var img = Utils.load_img("5")#remplacer "5" par data["Img"]
	image.texture = img

func _on_new_run_button_up():
	new_run.emit()
	queue_free()
	
