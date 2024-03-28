extends Node2D

var _player

@onready var level_transitions = $hallway_1/level_transitions
var level_transition_dictionary: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for transition in level_transitions.get_children():
		level_transition_dictionary[transition.name] = transition.get_child(1)
		


func initialize_player_overworld(player: player_character):
	# Spawn the player into the level
	_player = player
	_instantiate_player()


# Load the player into the game
func _instantiate_player():
	print("Loading Player")
	add_child(_player)
	
	if _player.player_overworld_transition == null:
		_player.instantiate_new_player()
		#player.position = player_spawn_position.position
	else:
		var player_entry_point = _player.player_overworld_transition.room_entry_point
		var player_spawn_point = level_transition_dictionary[player_entry_point]
		_player.position = player_spawn_point.global_position
