extends Node

var player_preload = preload("res://scenes/PlayerCharacter.tscn")
var _player

# instantiate a new copy of the player prefab
func _ready():
	_player = player_preload.instantiate()

func get_player():
	return _player
	
func set_player(player: player_character):
	_player = player


# Return the character dictionary of spritesheet profile
func get_character_spritesheet_profile():
	return _player.player_data.spritesheets.spritesheets
	
# Set the character spritesheet profile
func set_character_spritesheet_profile(spritesheet_profile):
	var new_spritesheets: player_base_spritesheets = player_base_spritesheets.new()
	var spritesheets: Array = []
	
	for spritesheet in spritesheet_profile:
		spritesheets.append(spritesheet)
	
	new_spritesheets.spritesheets_list = spritesheets
	_player.player_data.base_spritesheets = new_spritesheets

# Get and set the character default stats object
func set_character_stats(character_json_stats: Dictionary):
	var new_stats: player_stats = player_stats.new()
	
	var class_stats = []
	var class_attributes = []
	for class_stat in character_json_stats["classStats"]:
		var new_class_stat = stat.new()
		new_class_stat.stat_type = class_stat["statType"]
		new_class_stat.stat_name = class_stat["statName"]
		new_class_stat.max_stat_value = class_stat["maxStatValue"]
		class_stats.append(new_class_stat)
		
	for class_attribute in character_json_stats["classAttributes"]:
		var new_class_attribute = attribute.new()
		new_class_attribute.attribute_type = class_attribute["attributeType"]
		new_class_attribute.attribute_name = class_attribute["attributeName"]
		new_class_attribute.max_attribute_value = class_attribute["maxAttributeValue"]
		class_attributes.append(new_class_attribute)
		
	new_stats.stats_list = class_stats
	new_stats.attributes_list = class_attributes
	
	_player.player_data.base_stats = new_stats


func get_character_stats():
	return _player.player_data.base_stats
	
	
# Load and apply character stats
func load_character(loaded_player_data: player_base_data):
	
	_player.player_data.base_stats = loaded_player_data.base_stats
	_player.player_data.base_spritesheets = loaded_player_data.base_spritesheets
