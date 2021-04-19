extends Control



signal selectList(object)
signal editList(object)

var listId   : int
var listName : String



func _physics_process(_delta: float) -> void:
	$ListName.rect_size.x = 0



func setListId(value: int) -> void:
	listId = value

func setListName(text: String) -> void:
	$ListName.text = text
	$ListName.rect_size.x = 0
	listName = text



func openList() -> void:
	emit_signal('selectList', self)



func edit() -> void:
	emit_signal('editList', self)
