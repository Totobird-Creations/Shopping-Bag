extends Control



const SAVEFILE        : String  = 'user://lists.sv' # Overview File

const ITEM            : Object  = preload('res://Item.tscn')
const LIST            : Object  = preload('res://List.tscn')

const ACCELERATION    : float   = 10.0
const FRICTION        : float   = 250.0
const PRESSEDFRICTION : float   = 500.0



var saveData          : Dictionary

var editItemIndex



func _ready() -> void:
	saveData = readSaveData()
	loadSaveData()



func readSaveData() -> Dictionary:
	var saveFile = File.new()
	if (saveFile.file_exists(SAVEFILE)):
		saveFile.open(SAVEFILE, File.READ)
		var data = parse_json(saveFile.get_as_text())
		saveFile.close()
		if (data is Dictionary):
			#var verify = data.get('hash')
			#data.erase('hash')
			#if (hash(data) == verify or verify == null):
			#	return(data)
			return(data)

	return({
		'recent': 0,
		'sort': 0,
		'lists': {
			0: {
				'listName': 'My List',
				'items': []
			}
		}
	})



func writeSaveData() -> void:
	var saveFile = File.new()
	saveFile.open(SAVEFILE, File.WRITE)

	var data = saveData.duplicate()
	#data['hash'] = hash(data)

	saveFile.store_string(to_json(data))
	saveFile.close()



func loadSaveData() -> void:
	for child in $List/Vertical.get_children():
		child.queue_free()
	$Sidebar.clear()

	var value

	if (not saveData.get('lists') is Dictionary):
		saveData['lists'] = {}
	if (not saveData.get('recent') is int):
		if (saveData.get('recent') is String):
			saveData['recent'] = int(float(saveData['recent']))
		elif (saveData.get('recent') is float):
			saveData['recent'] = int(saveData['recent'])
		else: saveData['recent'] = 0
	if (not saveData.get('sort') is int):
		if (saveData.get('sort') is String):
			saveData['sort'] = int(float(saveData['sort']))
		elif (saveData.get('sort') is float):
			saveData['sort'] = int(saveData['sort'])
		else: saveData['sort'] = 0
	for key in saveData['lists'].keys():
		var temp = saveData['lists'][key]
		saveData['lists'].erase(key)
		if (not key is int):
			if (key is String):
				key = int(float(key))
			else:
				key = 0
		saveData['lists'][key] = temp
	if (not saveData['lists'].get(saveData['recent']) is Dictionary):
		saveData['lists'][saveData['recent']] = {}

	var data = saveData['lists'][saveData['recent']]

	value = data.get('listName')
	if (not value is String):
		if (value == null): value = 'My List'
		else: value = str(value)
	$TopBar/ListName.text = value

	if (not data.get('items') is Array):
		data['items'] = []

	if (saveData['sort'] == 1): $TopBar/SortMenu.sortBy_tags()
	else:                       $TopBar/SortMenu.sortBy_itemName()
	data['items'].sort_custom($TopBar/SortMenu, 'sortItems')

	var instance
	for item in data['items']:
		instance = ITEM.instance()
		value = item.get('itemName')
		if (not value is String):
			if (value == null): value = 'Missing Name'
			else: value = str(value)
		instance.setItemName(value)
		value = item.get('amount')
		if (not value is String):
			if (value == null): value = ''
			else: value = str(value)
		instance.setAmount(value)
		value = item.get('unit')
		if (not value is String):
			if (value == null): value = ''
			else: value = str(value)
		instance.setUnit(value)
		value = item.get('tags')
		if (not value is String):
			if (value == null): value = ''
			else: value = str(value)
		instance.setTags(value)
		value = item.get('notes')
		if (not value is String):
			if (value == null): value = ''
			else: value = str(value)
		instance.setNotes(value)
		value = item.get('checked')
		if (not value is bool):
			value = false
		instance.setChecked(value)
		instance.connect('edit', self, 'openEditItemMenu')
		instance.connect('viewNotes', self, 'openViewNotesMenu')
		instance.connect('updateCheck', self, 'updateItemCheck')
		$List/Vertical.add_child(instance)

	$EmptyWarning.visible = len(data['items']) <= 0

	var keys = saveData['lists'].keys()
	#keys.sort()

	for list in keys:
		data = saveData['lists'][list]
		instance = LIST.instance()
		value = data.get('listName')
		if (not value is String):
			if (value == null): value = 'My List'
			else: value = str(value)
		instance.setListId(list)
		instance.setListName(value)
		instance.connect('selectList', self, 'selectList')
		instance.connect('editList', self, 'openEditListMenu')
		$Sidebar.addList(instance)



func sortMethodChanged(method: int) -> void:
	saveData['sort'] = method

	writeSaveData()
	loadSaveData()



func openAddItemMenu() -> void:
	editItemIndex = null
	$EditItem.clear()
	$EditItem.open()

func openEditItemMenu(obj: Object) -> void:
	editItemIndex = obj.get_index()
	$EditItem.setItemName(obj.itemName)
	$EditItem.setAmount(obj.amount)
	$EditItem.setUnit(obj.unit)
	$EditItem.setTags(obj.tags)
	$EditItem.setNotes(obj.notes)
	$EditItem.setDeleteVisible(true)
	$EditItem.open()



func editItem(itemName: String, amount: String, unit: String, tags: String, notes: String, checked: bool) -> void:
	var sweeped = false
	if (editItemIndex is int):
		if (saveData['lists'][saveData['recent']]['items'][editItemIndex].get('sweeped') is bool):
			sweeped = saveData['lists'][saveData['recent']]['items'][editItemIndex]['sweeped']
	var data = {
		'amount'  : amount,
		'checked' : checked,
		'itemName': itemName,
		'notes'   : notes,
		'sweeped' : sweeped,
		'tags'    : tags,
		'unit'    : unit
	}

	if (editItemIndex is int):
		saveData['lists'][saveData['recent']]['items'][editItemIndex] = data
	else:
		saveData['lists'][saveData['recent']]['items'].append(data)

	writeSaveData()
	loadSaveData()



func updateItemCheck(object: Object) -> void:
	saveData['lists'][saveData['recent']]['items'][object.get_index()]['checked'] = object.checked
	saveData['lists'][saveData['recent']]['items'][object.get_index()]['sweeped'] = false

	writeSaveData()
	loadSaveData()



func deleteItem() -> void:
	saveData['lists'][saveData['recent']]['items'].remove(editItemIndex)

	writeSaveData()
	loadSaveData()




func openAddListMenu() -> void:
	editItemIndex = null
	$EditList.clear()
	$EditList.open()

func openEditListMenu(object: Object) -> void:
	editItemIndex = object.get_index()
	$EditList.setListName(object.listName)
	$EditList.setDeleteVisible(true)
	$EditList.setDeleteDisabled(object.listId == 0)
	$EditList.open()



func editList(listName: String) -> void:
	if (editItemIndex is int):
		saveData['lists'][editItemIndex]['listName'] = listName
	else:
		var newId = 0
		while (newId in saveData['lists'].keys()):
			newId += 1

		saveData['recent'] = newId
		saveData['lists'][newId] = {
			'items': [],
			'listName': listName
		}

	writeSaveData()
	loadSaveData()



func selectList(object: Object) -> void:
	$Sidebar.close()
	saveData['recent'] = object.listId

	writeSaveData()
	loadSaveData()



func deleteList():
	if (saveData['recent'] == editItemIndex):
		saveData['recent'] = 0

	saveData['lists'].erase(editItemIndex)

	writeSaveData()
	loadSaveData()



func openViewNotesMenu(object: Object) -> void:
	$ViewNotes.setNotes(object.notes)
	$ViewNotes.setObject(object)
	$ViewNotes.open()



func sweep() -> void:
	for item in saveData['lists'][saveData['recent']]['items']:
		if (item['checked'] == true):
			item['sweeped'] = true

	writeSaveData()
	loadSaveData()
