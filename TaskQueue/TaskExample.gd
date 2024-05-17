class_name TaskExample
extends Task


## Override This
#func _init() -> void:
	#pass


## Override This
func _prepare() -> void:
	# This function will be executed when the task is first added to the queue.
	# And each time the queue flushes until the task is ready.
	# Tasks can be marked as async to ignore the queue order.
	# Do any preperatory work here.
	# For example a task that wants to Draw a Card from a Deck, would query the deck
	# for whether or not it has a card to draw.
	# Then either the Task announces it is ready for completion, or waiting.
	# This function will be executed each time the queue flushes.
	
	# if is_waiting():
	# try to ready.
	# else:
	goto_ready()


## Override This
func _complete() -> void:
	# This function will be executed only once the Task is Ready
	# and it is the first task in the queue
	# Tasks can be marked as async to ignore the queue order.
	# Put the actual behavior of the task here.
	# For example the Draw Task card, would here, remove the card from the deck.
	# And place it in the players hand.
	# Then mark itself as completed
	goto_completed()


## Override This
func _cancel() -> void:
	# In case you need to clean something up when a task has failed.
	goto_failed()
