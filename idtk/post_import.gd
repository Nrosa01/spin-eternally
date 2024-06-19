@tool

func post_import(entity_layer: LDTKEntityLayer) -> LDTKEntityLayer:
	print("Importing entities on " + str(entity_layer))
	
	var definition: Dictionary = entity_layer.definition
	var entities: Array = entity_layer.entities
	for entity in entities:
		if entity.identifier == "Tube":
			print("Entitty wiwth " + str(entity.fields.Point))
			var node := Node2D.new()
			node.name = "New Tube"
			print(node)
			entity_layer.add_child(node)
		pass

	return entity_layer
