@tool

func post_import(entity_layer: LDTKEntityLayer) -> LDTKEntityLayer:
	print("Post import entity test")
	var definition: Dictionary = entity_layer.definition
	print(definition)
	var entities: Array = entity_layer.entities
	for entity in entities:
		# Perform operations here
		pass

	return entity_layer
