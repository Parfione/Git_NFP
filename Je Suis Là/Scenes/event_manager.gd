extends Control

const DATA_GM_PATH = "res://data/DATA_GM.json"
const DATA_FACT_PATH = "res://data/DATA_FACT.json"
const CHOICE_BUTTON_SCENE = preload("res://Scenes/Choicebutton.tscn")
const END_SCENE = preload("res://Scenes/End.tscn")

const LETTER_DURATION = 0.05
const CHOICES_FADEIN_DURATION = 1.5

var data
var fact_data
var event_choices = {}
var used_names = []
var nb_runs
var current_event = "1A"

@onready var progress_bar = %ProgressBar

@onready var choices_container = %ChoicesContainer
@onready var sentence = %Sentence
@onready var background = %Background
@onready var click_wall = %ClickWall

# Called when the node enters the scene tree for the first time.
func _ready():
	#data = CsvImporter.ImportCSV(DATA_GM_PATH)
	#fact_data = CsvImporter.ImportCSV(DATA_FACT_PATH)
	data = Utils.load_JSON(DATA_GM_PATH)
	fact_data = Utils.load_JSON(DATA_FACT_PATH)
	nb_runs = float(len(Array(data["1A"]["Words"].split(","))))
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
	return "[center][wave freq=0.5 amp=0.1 connected=0]" + formatted_sentence

func load_event(event:String):
	current_event = data[event]
	current_event["Event"] = event
	var sentence_text = current_event["Sentence"]
	var words = Array(current_event["Words"].split(","))
	var nb_words = int(current_event["Nb_Words"])
	var links = Array(current_event["Links"].split(","))
	free_choices()
	create_choices(words,links,nb_words) #ajouter conditions comme paramètre
	sentence.text = format_sentence(sentence_text)
	pop_elements()

func pop_elements():
	click_wall.visible = true
	sentence.visible_ratio = 0.0
	choices_container.modulate.a = 0.0
	
	var tween = create_tween()
	
	var sentence_duration = float(len(sentence.text))* LETTER_DURATION
	tween.tween_property(sentence,"visible_ratio",1.0,sentence_duration).set_trans(Tween.TRANS_SINE)
	tween.tween_property(choices_container,"modulate:a",1.0,CHOICES_FADEIN_DURATION).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	await get_tree().create_timer((sentence_duration+CHOICES_FADEIN_DURATION*0.25)*0.9).timeout
	click_wall.visible = false

func load_end(end_event: String): 
	print(end_event)
	var end_data = data[end_event]
	# get all data ici
	# ensuite afficher écran de fin
	
	var end = END_SCENE.instantiate()
	add_child(end)
	end.init(format_sentence(end_data["Sentence"]),end_data,fact_data)
	end.new_run.connect(new_run)
	

func link_to(event:String,word:String):
	event_choices[current_event["Event"]] = word
	if current_event["Event"] == "1A":
		used_names.append(word)
	
	if data[event]["Links"] == "":
		load_end(event)
	else:
		load_event(event)
		

func new_run():
	background.z_index = 1
	await create_tween().tween_property(progress_bar,"value",float(len(used_names)) / nb_runs,1.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).finished
	background.z_index = 0
	load_event("1A")
	
