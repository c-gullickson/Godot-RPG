extends CharacterBody2D
class_name player_character

const Constants = preload("res://components/constants/Enumerations.gd")

@onready var lpcAnimator = $LPCAnimatedSprite2D as LPCAnimatedSprite2D
@onready var characterAnimation = $CharacterAnimationComponent
@onready var character_inventory: inventory = $CharacterInventoryComponent

@export var speed = 200
@export var move_direction = Constants.MoveDirection.SOUTH

var player_data: player_base_data = player_base_data.new()
var LPCSpriteType = preload("res://addons/LPCAnimatedSprite/LPCSpriteSheet.gd")
var CharacterSpritesheet = preload("res://classes/Character_Spritesheet.gd")

var can_use_player_input: bool = true
var player_state: Constants.CharacterStates = Constants.CharacterStates.OVERWORLD

var player_overworld_transition: overworld_transition

var is_equipment_ui_open: bool = false

func _ready():
	#TODO: Should change character_data to character profile, where inventory, stats and more are loaded
	#character_data = CharacterLoader.get_character_stats()
	var player = CharacterLoader.get_player()
	player_data = player.player_data
	
	lpcAnimator.add_spritesheet_profile(player_data.base_spritesheets.spritesheets_list)
	characterAnimation.initialize(lpcAnimator)
	character_inventory.initialize()

func instantiate_new_player():
	#for gear in character_data["startingGear"]:
		#var gear_path = gear["gearPath"]
		#
		## Build direct path to gear spritesheet
		#var spritesheet_definition = JsonLoader.load_json_by_path(gear_path)
		#var spritesheet_type = spritesheet_definition["type_name"]
		#var gear_base_path = spritesheet_definition["layer_1"][character_data["gender"]] + gear["gearVariant"]
		#var gear_base_layer = spritesheet_definition["layer_1"]["zPos"]
		#
		#var full_path = "res://Assets/spritesheets/" + gear_base_path + ".png"
		#var spritesheet_texture = load(full_path)
		#add_sheet(spritesheet_type, gear_base_path, gear_base_layer)
	pass

# Using the file path of the selected part, append it to the LPC Array
func add_sheet(spritesheet_type: String, new_sheet_path: String, layer: int):
	print("New SHeet Path: " + new_sheet_path)
	#
	var full_path = "res://Assets/spritesheets/" + new_sheet_path + ".png"
	var spritesheet_texture = load(full_path)
	
	var lpc_spritesheet: LPCSpriteSheet = LPCSpriteSheet.new()
	lpc_spritesheet.SpriteSheet = spritesheet_texture
	lpc_spritesheet.Name = "body"
	lpc_spritesheet.SpriteType = LPCSpriteType.SpriteTypeEnum.Normal
	
	var character_spritesheet: Character_Spritesheet = CharacterSpritesheet.new()
	character_spritesheet.spritesheet_type = spritesheet_type
	character_spritesheet.spritesheet = lpc_spritesheet
	character_spritesheet.spritesheet_layer = layer
	
	lpcAnimator.add_player_spritesheet_layer(character_spritesheet)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_key_pressed(KEY_SPACE):
		print("Open Character Inventory")
		open_equipment_selection()
	
	# Get and calculate the velocity to move the unit based on user input
	velocity = movement_input() * speed
	characterAnimation.modify_move_animation(velocity, move_direction)
	
	move_and_slide()


# Get input for player movement
func movement_input() -> Vector2: 
	var input_vector = Vector2()  # Reset input_vector

	if can_use_player_input and player_state == Constants.CharacterStates.OVERWORLD:
		if Input.is_action_pressed("MoveRight"):
			input_vector.x += 1
			move_direction = Constants.MoveDirection.EAST
		if Input.is_action_pressed("MoveLeft"):
			input_vector.x -= 1
			move_direction = Constants.MoveDirection.WEST
		if Input.is_action_pressed("MoveDown"):
			input_vector.y += 1
			move_direction = Constants.MoveDirection.SOUTH
		if Input.is_action_pressed("MoveUp"):
			input_vector.y -= 1
			move_direction = Constants.MoveDirection.NORTH
		
		# Only allow for straight forward paths
		if input_vector.x != 0:
			velocity = Vector2(input_vector.x, 0)
		elif input_vector.y != 0:
			velocity = Vector2(0, input_vector.y)
		else:
			velocity = Vector2()
		
	# Normalize the input_vector to maintain consistent speed in all directions
	input_vector = input_vector.normalized()
	
	return input_vector

# Set a flag to determine if the player input is taken into effect
func set_can_use_player_input(use_input: bool):
	can_use_player_input = use_input

# set the curent state of the player
func set_state(state: Constants.CharacterStates):
	player_state = state

# Update the player with data of it's last transition
func set_transition(transition: overworld_transition):
	player_overworld_transition = transition


# Add items to the player inventory
func add_item_to_inventory(item: item_data, amount: int):
	print("Add new item to character inventory")
	character_inventory.add_item(item, amount)
	OverworldUi.add_message("Added: " + item.item_name + " to Inventory")

func check_items_in_inventory(item_to_check: String) -> bool:
	return character_inventory.check_inventory_for_item(item_to_check)

# Open and place a new instance of the equipment control
func open_equipment_selection():
	if player_state == Constants.CharacterStates.OVERWORLD:
		if is_equipment_ui_open:
			return
		OverworldUi.open_equipment_control(character_inventory.get_all_items())
		is_equipment_ui_open = true

