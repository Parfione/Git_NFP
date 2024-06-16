extends Control

const DATA_GM_PATH = "res://DATA_GM.csv"
const CHOICE_BUTTON_SCENE = preload("res://Scenes/Choicebutton.tscn")

var data = CSVImporter.ImportCSV(DATA_GM_PATH)
var event_choices = {}
var used_names = []
var current_event = "1A"

@onready var choices_container = %ChoicesContainer
@onready var sentence = %Sentence

# Called when the node enters the scene tree for the first time.
func _ready():
	load_event(current_event)
	

func free_choices():
	for choice in choices_container.get_children():
		choice.queue_free()

func check_condition(word,link):
	if !word: return false
	return !word in used_names

func create_choices(words:Array,links:Array,nb_words:int,conditions:Array = []):
	var cpt = 0 
	var random_index = []
	for i in len(words): 
		random_index.append(i)
	random_index.shuffle()
	for i in random_index:
		#Check conditions
		var check:bool = check_condition(words[i],links[i])
		if check:
			var button = CHOICE_BUTTON_SCENE.instantiate()
			choices_container.add_child(button)
			var b_condition = ""  #Il faut mettre conditions[i]
			button.init(words[i],links[i],b_condition)
			button.link_to.connect(link_to)
			cpt += 1
			if cpt >= nb_words:
				break

func format_sentence(sentence:String):
	var formatted_sentence = sentence
	for k in event_choices.keys(): 
		formatted_sentence = formatted_sentence.replace("$"+k,event_choices[k])
	return "[center]" + formatted_sentence

func load_event(event:String):
	current_event = event 
	var event_data = data[current_event]
	var sentence_text = event_data["Sentence"]
	var words = Array(event_data["Words"].split(","))
	var nb_words = int(event_data["Nb_Words"])
	var links = Array(event_data["Links"].split(","))
	free_choices()
	create_choices(words,links,nb_words) #ajouter conditions comme paramètre
	sentence.text = format_sentence(sentence_text)
	#await get_tree().process_frame
	#print(current_event)
	#if len(choices_container.get_children())==0:
		#await get_tree().create_timer(1).timeout
	#	load_event("1A")
	

func link_to(event:String,word:String):
	event_choices[current_event] = word
	if current_event == "1A":
		used_names.append(word)
		
	load_event(event)
	


