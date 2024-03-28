extends Node

var player_preload = preload("res://scenes/PlayerCharacter.tscn")
var _player

var character_data: Dictionary = {}
var character_sprite_profile: Dictionary = {}

# instantiate a new copy of the player prefab
func _ready():
	_player = player_preload.instantiate()

func get_player():
	return _player
	
func set_player(player: player_character):
	_player = player


# Return the character dictionary of spritesheet profile
func get_character_spritesheet_profile():
	return self.character_sprite_profile
	
# Set the character spritesheet profile
func set_character_spritesheet_profile(spritesheet_profile):
	self.character_sprite_profile = spritesheet_profile

# Get and set the character default json object
func set_character_data(character_data: Dictionary):
	self.character_data = character_data
	
func get_character_data():
	return self.character_data
