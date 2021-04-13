extends Control



signal editItem(itemName, amount, unit, tags, notes, checked)
signal deleteItem()



func setItemName(text: String):
	$Menu/Background/Name.text = text
	nameChanged(text)

func setAmount(text: String):
	$Menu/Background/Amount.text = text

func setUnit(text: String):
	$Menu/Background/Unit.text = text

func setTags(text: String):
	$Menu/Background/Tags.text = text

func setNotes(text: String):
	$Menu/Background/Notes.text = text

func setDeleteVisible(value: bool):
	$Menu/Background/Buttons/Delete.visible = value



func clear() -> void:
	setItemName('')
	setAmount('')
	setUnit('')
	setTags('')
	setNotes('')
	setDeleteVisible(false)
	nameChanged('')



func open() -> void:
	$Animation.play('Open')

func close() -> void:
	$Animation.play('Close')



func nameChanged(newValue: String) -> void:
	$Menu/Background/Buttons/Confirm.disabled = len(newValue) <= 0



func confirm() -> void:
	var itemName = $Menu/Background/Name.text
	var amount   = $Menu/Background/Amount.text
	var unit     = $Menu/Background/Unit.text
	var tags     = $Menu/Background/Tags.text
	var notes    = $Menu/Background/Notes.text
	emit_signal('editItem', itemName, amount, unit, tags, notes, false)
	close()



func delete() -> void:
	emit_signal('deleteItem')
	close()
