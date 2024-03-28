extends Control

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
