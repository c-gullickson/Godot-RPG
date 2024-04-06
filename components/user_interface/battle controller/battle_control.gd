extends Control

class_name battle_control

var _player: player_character

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func initialize(player: player_character):
	_player = player

# Open the container to allow the player to equip different items for battle
func _on_player_equipment_button_pressed():
	OverworldUi.open_equipment_control(_player.character_inventory)

func close_equipment_control():
	OverworldUi.close_equipment_control()
