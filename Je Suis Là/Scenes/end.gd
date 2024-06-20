extends Control


signal new_run 

const FACT_ITEM_SCENE = preload("res://fact_item.tscn")

const LETTER_DURATION = 0.06

@onready var fact_container = %FactContainer
@onready var end_sentence = %End_Sentence
@onready var image = %Image
@onready var center_sentence = %Center_Sentence
@onready var fact_end = %FactEnd

var tween : Tween

func _input(event):
	if event.is_action_pressed("Click"):
		tween.set_speed_scale(3.0)
	elif event.is_action_released("Click"):
		tween.set_speed_scale(1.0)

func create_fact(ID,fact_data):
	var item = FACT_ITEM_SCENE.instantiate()
	fact_container.add_child(item)
	item.init(fact_data[ID]["Fact"],fact_data[ID]["Lien"])


func init(sentence:String,data,fact_data):
	if data.Facts:
		end_sentence.text = sentence
		#var fact_array = Array("F1,F2,F3".split(","))#remplacer "F1,F2,F3" par data["Facts"]
		var fact_array = Array(data["Facts"].split(","))#remplacer "F1,F2,F3" par data["Facts"]
		for fact in fact_array:
			if fact: create_fact(fact,fact_data)
		var img = Utils.load_img("5")#remplacer "5" par data["Img"]
		image.texture = img
		read_sentence(end_sentence)
	else:
		center_sentence.text = sentence
		center_sentence.visible = true
		fact_end.visible = false
		read_sentence(center_sentence)

func read_sentence(sentence_node):
	tween = create_tween()
	var sentence_duration = float(len(sentence_node.text))*LETTER_DURATION
	#AudioManager.typing(sentence_duration)
	tween.tween_property(sentence_node,"visible_ratio",1.0,sentence_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	

func _on_new_run_button_up():
	AudioManager.vote()
	new_run.emit()
	queue_free()
	
