extends character_base
class_name player_character

@onready var character_inventory: inventory = $CharacterInventoryComponent


var player_data: player_base_data = player_base_data.new()
var LPCSpriteType = preload("res://addons/LPCAnimatedSprite/LPCSpriteSheet.gd")
var CharacterSpritesheet = preload("res://classes/Character_Spritesheet.gd")

var can_use_player_input: bool = true
var player_state: Constants.CharacterStates = Constants.CharacterStates.OVERWORLD

var player_overworld_transition: overworld_transition
var is_equipment_ui_open: bool = false

func _ready():
	OverworldUi.connect("equipment_control_closed", Callable(self, "close_equipment_selection"))
	var player = CharacterLoader.get_player()
	player_data = player.player_data
	set_character_stats(player_data.base_stats)
	
	lpc_animator.add_spritesheet_profile(player_data.base_spritesheets.spritesheets_list)
	character_animation.initialize(lpc_animator)
	character_inventory.initialize(lpc_animator, "player")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Listen for key inputs
	if Input.is_key_pressed(KEY_SPACE):
		print("Open Character Inventory")
		open_equipment_selection()
	
	# Get and calculate the velocity to move the unit based on user input
	velocity = movement_input() * speed
	character_animation.modify_move_animation(velocity, move_direction)
	
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
		OverworldUi.open_equipment_control(character_inventory)
		is_equipment_ui_open = true


func close_equipment_selection():
	if player_state == Constants.CharacterStates.OVERWORLD:
		is_equipment_ui_open = false
