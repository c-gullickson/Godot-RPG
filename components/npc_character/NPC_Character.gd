extends character_base

class_name npc_character

# Path of json character data to load
@export var character_data_path: String
var character_data: Dictionary

var LPCSpriteType = preload("res://addons/LPCAnimatedSprite/LPCSpriteSheet.gd")
var CharacterSpritesheet = preload("res://classes/Character_Spritesheet.gd")
var character_state: Constants.CharacterStates = Constants.CharacterStates.DEAD


func _ready():
	character_data = JsonLoader.load_json_by_path(character_data_path)
	var base_texture = load(character_data["characterDefinition"]["characterPresetSpritePath"])
	lpc_animator.add_sheet("base", "", 1, base_texture, "npc")
	character_animation.initialize(lpc_animator)
	load_character_stats(character_data["characterDefinition"]["stats"])

# Return the index for what spawn position the enemy should be placed on
func get_battle_position():
	return character_data["characterDefinition"]["battlePosition"]


# Apply a death animation
func set_is_dead(is_dead: bool):
	character_animation.set_dead_animation()


# Interaction when player enters trigger scene
func _on_interact_trigger_body_entered(body):
	if "Player" in body.name:
		if character_state == Constants.CharacterStates.DEAD:
			var death_dialog = character_data["characterDefinition"]["characterDeathDialog"]
			Dialogic.start_timeline(death_dialog)
