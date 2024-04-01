extends CharacterBody2D
class_name npc_character

const Constants = preload("res://components/constants/Enumerations.gd")

# Path of json character data to load
@export var character_data_path: String
var character_data: Dictionary

@onready var lpcAnimator = $LPCAnimatedSprite2D as LPCAnimatedSprite2D
@onready var characterAnimation = $CharacterAnimationComponent

@export var speed = 200
@export var move_direction = Constants.MoveDirection.SOUTH

var follow_path
var should_follow_path: bool = false
var npc_position: Vector2
var npc_position_last: Vector2

var LPCSpriteType = preload("res://addons/LPCAnimatedSprite/LPCSpriteSheet.gd")
var CharacterSpritesheet = preload("res://classes/Character_Spritesheet.gd")
var character_state: Constants.CharacterStates = Constants.CharacterStates.DEAD


func _ready():
	character_data = JsonLoader.load_json_by_path(character_data_path)
	add_base_sheet("base", character_data["characterDefinition"]["characterPresetSpritePath"], 1)
	characterAnimation.initialize(lpcAnimator)
	
func _process(delta):
	velocity = Vector2()
	
	if should_follow_path:
		if follow_path.progress_ratio < 1:
			follow_path.progress_ratio += 0.05 * delta
			npc_position = follow_path.position
			npc_position_last = follow_path.position
		else:
			npc_position = Vector2()
	else:
		should_follow_path = false
	
	if follow_path:
		characterAnimation.modify_move_animation_by_pathfollow(npc_position)

# Using the file path of the selected part, append it to the LPC Array
func add_base_sheet(spritesheet_type: String, sprite_path: String, layer: int):
	var spritesheet_texture = load(sprite_path)
	
	var lpc_spritesheet: LPCSpriteSheet = LPCSpriteSheet.new()
	lpc_spritesheet.SpriteSheet = spritesheet_texture
	lpc_spritesheet.Name = "body"
	lpc_spritesheet.SpriteType = LPCSpriteType.SpriteTypeEnum.Normal
	
	var character_spritesheet = CharacterSpritesheet.new()
	character_spritesheet.spritesheet_type = spritesheet_type
	character_spritesheet.spritesheet = lpc_spritesheet
	character_spritesheet.spritesheet_layer = layer
	
	lpcAnimator.add_npc_spritesheet_layer(character_spritesheet)

func start_follow_path():
	print("Starting NPC Follow Path")
	should_follow_path = true
	follow_path = get_parent()
	
# Tell the NPC to stop following the path, but not to reset
func pause_follow_path():
	should_follow_path = false
	follow_path = null
	
# Return the index for what spawn position the enemy should be placed on
func get_battle_position():
	return character_data["characterDefinition"]["battlePosition"]

# Apply a death animation
func set_is_dead(is_dead: bool):
	characterAnimation.set_dead_animation()

# Interaction when player enters trigger scene
func _on_interact_trigger_body_entered(body):
	if "Player" in body.name:
		if character_state == Constants.CharacterStates.DEAD:
			var death_dialog = character_data["characterDefinition"]["characterDeathDialog"]
			Dialogic.start_timeline(death_dialog)
