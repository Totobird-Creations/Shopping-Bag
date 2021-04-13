extends Control



signal edit(object)
signal viewNotes(object)
signal updateCheck(object)

var itemName : String = ''
var amount   : String = ''
var unit     : String = ''
var tags     : String = ''
var notes    : String = ''
var checked  : bool   = false



func _physics_process(_delta: float) -> void:
	$ItemName.rect_size.x = 0



func setItemName(text: String) -> void:
	$ItemName.text = text
	$ItemName.rect_size.x = 0
	itemName = text



func setAmount(text: String) -> void:
	$Amount.text = text
	$Amount.rect_size.x = 0
	amount = text



func setUnit(text: String) -> void:
	$Amount/Unit.text = text
	$Amount/Unit.rect_size.x = 0
	unit = text



func setTags(text: String) -> void:
	$Tags.text = text
	tags = text



func setNotes(text: String) -> void:
	$ItemName/Info.visible = len(text) >= 1
	notes = text



func setChecked(value: bool) -> void:
	if (value):
		$ItemName.modulate.a = 0.5
		$Amount.modulate.a = 0.5
	else:
		$ItemName.modulate.a = 1.0
		$Amount.modulate.a = 1.0
	$Check.pressed = value
	$Check/Check.visible = value
	checked = value



func edit() -> void:
	emit_signal('edit', self)



func checkToggled(pressed: bool) -> void:
	setChecked(pressed)
	emit_signal('updateCheck', self)



func viewNotes() -> void:
	emit_signal('viewNotes', self)
