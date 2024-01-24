@tool
extends Resource
class_name MaterialDefinition

@export var init : bool = true: 
	set(new_value):
		init = false
		init_dic()

@export var _definitions: Dictionary
@export var definitions: Dictionary

func create_data() -> Dictionary:
	return {
		bouncable = true,
		sound = FMODAsset
}

func init_dic():
	var keys = MaterialEnum.MaterialTile.keys()
	
	for value in MaterialEnum.MaterialTile.values():
		if not definitions[value]:
			print("Setting value for " + str(value))
			definitions[value] = MaterialProperties.new()
		
		_definitions[keys[value]] = definitions[value]
