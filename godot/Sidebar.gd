extends Control



signal addList()



func open() -> void:
	$Animation.play('Open')

func close() -> void:
	$Animation.play('Close')



func createList():
	emit_signal('addList')



func clear():
	for child in $Menu/Background/List/Vertical.get_children():
		child.queue_free()



func addList(object):
	$Menu/Background/List/Vertical.add_child(object)



func openList(listId):
	close()
	emit_signal('openList', listId)



func editList(object):
	emit_signal('editList', object)
