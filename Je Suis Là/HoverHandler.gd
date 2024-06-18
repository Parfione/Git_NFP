extends Node

@export var HOVER_OFFSET = Vector2(2,2)
@export var SCALE_MULT = Vector2(1.05,1.05)

var parent : Control
var base_pos : Vector2
var base_scale : Vector2

var tween : Tween

func _ready():
	if !get_parent() is Control: return
	parent = get_parent()
	parent.mouse_entered.connect(_on_mouse_entered)
	parent.mouse_exited.connect(_on_mouse_exited)
	parent.tree_exiting.connect(queue_free)
	await get_tree().process_frame
	base_pos = parent.position
	base_scale = parent.scale
	parent.pivot_offset = parent.size*0.5

func _on_mouse_entered():
	if tween and tween.is_running(): tween.kill()
	if !is_instance_valid(self) or !is_instance_valid(parent): return
	tween = create_tween()
	tween.set_parallel()
	tween.tween_property(parent,"position",base_pos-HOVER_OFFSET,0.15).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(parent,"scale",base_scale*SCALE_MULT,0.15).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	


func _on_mouse_exited():
	if tween and tween.is_running(): tween.kill()
	#await get_tree().process_frame
	if !is_instance_valid(self) or !is_instance_valid(parent): return
	tween = create_tween()
	if !is_instance_valid(self) or !is_instance_valid(parent) or !is_instance_valid(tween): return
	tween.set_parallel()
	tween.tween_property(parent,"position",base_pos,0.15).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(parent,"scale",base_scale,0.15).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
