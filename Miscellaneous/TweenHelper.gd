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
