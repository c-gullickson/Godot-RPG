class CharacterBaseClass:
	var class_type: String = ""
	var gender: String = ""
	var body: String = ""
	var partType: Array = []
	
# Containe all of the subtypes for the current container
class CharacterPartContainer:
	var container: String = ""
	var containerText: String = ""
	var containerTypes: Array = []

# Show each container of a particular part
class CharacterSubPartContainer:
	var subtypeContainer: String = ""
	var subtypeText: String = ""
	var subtypePath: String = ""
