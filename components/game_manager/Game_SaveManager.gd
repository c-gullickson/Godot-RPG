extends Node

var save_path := "user://save_data.tres"
var save_state: game_save_state 

# Called when the node enters the scene tree for the first time.
func _ready():
	save_state = game_save_state.new()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		print("Save Game")
		save_game()

# Global function to save the game
func save_game():
	_save_character()
	
	_save_file()

# Global function to load the game
func load_game():
	_load_file()


####
# Private Functions
####

# Save the existing character stats into a resource
func _save_character():
	var player = CharacterLoader.get_player()
	save_state.player_data = player.player_data


# Save all of the required game states
func _save_file():
	var error := ResourceSaver.save(save_state, save_path)
	if error:
		print("An error happened while saving data: ", error)
	
# Load all of the saved data
func _load_file():
	save_state = load(save_path)
	
	CharacterLoader.load_character(save_state.player_data)
	
