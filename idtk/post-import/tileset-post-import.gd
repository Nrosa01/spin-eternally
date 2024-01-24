@tool

func post_import(tilesets: Dictionary) -> Dictionary:
	# Behaviour goes here
	print(tilesets)
	
	for tileset in tilesets:
		print(tilesets.get(tileset).get_classname())
	
	return tilesets
