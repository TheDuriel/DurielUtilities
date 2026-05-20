class_name TweenHelper
extends RefCounted


static func kill(tween: Tween) -> Variant:
	if tween and (tween.is_valid() or tween.is_running()):
		tween.kill()
	return null


static func create(owner: Node,
		tween_ease: Tween.EaseType = Tween.EASE_IN,
		tween_trans: Tween.TransitionType = Tween.TRANS_LINEAR) -> Tween:
	
	var t: Tween = owner.create_tween()
	t.set_ease(tween_ease)
	t.set_trans(tween_trans)
	return t


static func replace(owner: Node, old_tween: Tween) -> Tween:
	kill(old_tween)
	return create(owner)


static func add_subtween(owner: Node, tween: Tween) -> Tween:
	var t: Tween = owner.create_tween()
	tween.tween_subtween(t)
	return t


static func is_finished(tween: Tween) -> bool:
	if tween == null:
		return true
	if not tween.is_running():
		return true
	return false
