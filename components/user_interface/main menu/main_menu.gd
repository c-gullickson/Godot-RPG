extends Control

@export var game_scene_path = "res://scenes/LevelManager/Level1/level_1_cells_1.tscn"
var character_creation_scene_path = "res://scenes/character_creator.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_new_game_button_pressed():
	print("Start New Game")
	GameSceneManager.load_scene_auto(character_creation_scene_path)


func _on_load_character_button_pressed():
	print("Load Character")
	GameSaveManager.load_game()
		
	print("Starting Game")
	var player = CharacterLoader.get_player()
	GameSceneManager.load_scene_overworld(game_scene_path, player)
