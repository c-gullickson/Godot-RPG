extends Node
class_name  battle_dungeon_combat

signal on_battle_order_change(battling_characters)

var character_queue = []


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


func start_battle(battling_characters: Array):
	battling_characters.sort_custom(Callable(self,"character_speed_sort"))
	for character: character_base in battling_characters:
		var char_speed: attribute = find_attribute_by_type(character._character_stats.attributes_list, "overworldSpeed")
	
	emit_signal("on_battle_order_change", battling_characters)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Sort the characters in battle by speed
func character_speed_sort(a: character_base, b: character_base):
	var character_a_attribute: attribute = find_attribute_by_type(a._character_stats.attributes_list, "overworldSpeed")
	var character_b_attribute: attribute = find_attribute_by_type(b._character_stats.attributes_list, "overworldSpeed")
	
	if character_a_attribute.attribute_value > character_b_attribute.attribute_value:
		return true
	return false


# Return a specific attribute from the list
func find_attribute_by_type(attributes: Array, lookup_attribute: String):
	for att: attribute in attributes:
		if att.attribute_type == lookup_attribute:
			return att
	return null
