extends Control



signal editItem(object)

var object



func setNotes(text: String):
	$Menu/Background/Notes.text = text

func setObject(value: Object):
	object = value



func open() -> void:
	$Animation.play('Open')

func close() -> void:
	$Animation.play('Close')



func edit() -> void:
	close()
	emit_signal('editItem', object)
