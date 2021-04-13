extends Control



const DELETE = preload('res://Assets/Delete.png')
const DELETEDISABLED = preload('res://Assets/DeleteDisabled.png')



signal editList(listName)
signal deleteList()



func setListName(text: String) -> void:
	$Menu/Background/Name.text = text
	nameChanged(text)

func setDeleteVisible(value: bool):
	$Menu/Background/Buttons/Delete.visible = value

func setDeleteDisabled(value: bool):
	$Menu/Background/Buttons/Delete.disabled = value
	if (value):
		$Menu/Background/Buttons/Delete/Icon.texture = DELETEDISABLED
	else:
		$Menu/Background/Buttons/Delete/Icon.texture = DELETE



func clear() -> void:
	setListName('')
	setDeleteVisible(false)
	setDeleteDisabled(true)



func open() -> void:
	$Animation.play('Open')

func close() -> void:
	$Animation.play('Close')



func nameChanged(newValue: String) -> void:
	$Menu/Background/Buttons/Confirm.disabled = len(newValue) <= 0



func confirm() -> void:
	var listName = $Menu/Background/Name.text
	emit_signal('editList', listName)
	close()



func delete() -> void:
	emit_signal('deleteList')
	close()
