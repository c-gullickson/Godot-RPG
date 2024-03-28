extends Control

@export var game_scene_path = "res://scenes/LevelManager/Level1/level_1_cells_1.tscn"

@onready var _character_start_button = $BackgroundPanelContainer/VSplitContainer/PanelContainer/StartButton

func _ready():
	_character_start_button.connect("custom_character_start", Callable(self, "_start_game_with_character"))

# Delegate a new signal to the main game object that a character has been 
# instantiated and the game is ready to be started
func _start_game_with_character():
	
	print("Starting Game")
	var player = CharacterLoader.get_player()
	GameSceneManager.load_scene_overworld(game_scene_path, player)
