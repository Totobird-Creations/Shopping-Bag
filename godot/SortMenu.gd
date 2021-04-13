extends Control



signal sortChanged(method)

enum {
	SORT_ITEMNAME,
	SORT_TAGS
}
var sort

var isOpen = false



func open() -> void:
	$Animation.play('Open')
	isOpen = true

func close() -> void:
	$Animation.play('Close')
	isOpen = false

func toggle() -> void:
	if (isOpen):
		close()
	else:
		open()



func emitModifiedSignal() -> void:
	emit_signal('sortChanged', sort)

func sortBy() -> void:
	$Background/ItemName/Check.visible = false
	$Background/Tags/Check.visible = false

func sortBy_itemName() -> void:
	sort = SORT_ITEMNAME
	sortBy()
	$Background/ItemName/Check.visible = true

func sortBy_tags() -> void:
	sort = SORT_TAGS
	sortBy()
	$Background/Tags/Check.visible = true



func sortItems(a: Dictionary, b: Dictionary) -> bool:
	if (not a.get('sweeped') is bool):
		a['sweeped'] = false
	if (not b.get('sweeped') is bool):
		b['sweeped'] = false
	if (not a.get('itemName') is String):
		if (a.get('itemName') == null):
			a['itemName'] = 'Missing Name'
		else:
			a['itemName'] = str(a['itemName'])
	if (not b.get('itemName') is String):
		if (b.get('itemName') == null):
			b['itemName'] = 'Missing Name'
		else:
			b['itemName'] = str(b['itemName'])
	if (not a.get('tags') is bool):
		if (a.get('tags') == null):
			a['tags'] = ''
		else:
			a['tags'] = str(a['tags'])
	if (not b.get('tags') is bool):
		if (b.get('tags') == null):
			b['tags'] = ''
		else:
			b['tags'] = str(b['tags'])

	if (a['sweeped'] and not b['sweeped']):
		return(false)
	if (b['sweeped'] and not a['sweeped']):
		return(true)

	if (sort == SORT_ITEMNAME):
		return(b['itemName'] > a['itemName'])

	elif (sort == SORT_TAGS):
		if (b['tags'] == a['tags']):
			return(b['itemName'] > a['itemName'])
		else:
			return(b['tags'] > a['tags'])

	return(true)
