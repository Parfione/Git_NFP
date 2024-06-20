extends Node

@export var HOVER_OFFSET = Vector2(2,2)
@export var SCALE_MULT = Vector2(1.05,1.05)

var parent : Control
var setup := false
var base_pos : Vector2
var base_scale : Vector2

var tween : Tween

var mouse_on := false

func _ready():
	if !get_parent() is Control: return
	parent = get_parent()
	parent.mouse_entered.connect(_on_mouse_entered)
	parent.mouse_exited.connect(_on_mouse_exited)
	parent.tree_exiting.connect(queue_free)

func _on_mouse_entered():
	mouse_on = true
	if !parent.is_inside_tree() or !is_inside_tree(): return
	if !setup:
		await get_tree().create_timer(0.01).timeout
		setup = true
		base_pos = parent.position
		base_scale = parent.scale
		parent.pivot_offset = parent.size*0.5
	if !mouse_on: return
	if tween and tween.is_running(): tween.kill()
	if !is_instance_valid(self) or !is_instance_valid(parent): return
	#AudioManager.hover()
	tween = create_tween()
	tween.set_parallel()
	tween.tween_property(parent,"position",base_pos-HOVER_OFFSET,0.15).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(parent,"scale",base_scale*SCALE_MULT,0.15).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	


func _on_mouse_exited():
	mouse_on = false
	if !setup : return
	if !parent.is_inside_tree() or !is_inside_tree(): return
	if tween and tween.is_running(): tween.kill()
	if !is_instance_valid(self) or !is_instance_valid(parent): return
	tween = create_tween()
	if !is_instance_valid(self) or !is_instance_valid(parent) or !is_instance_valid(tween): return
	tween.set_parallel()
	tween.tween_property(parent,"position",base_pos,0.15).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(parent,"scale",base_scale,0.15).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
