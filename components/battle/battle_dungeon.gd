extends Node2D
class_name battle_dungeon

const Constants = preload("res://components/constants/Enumerations.gd")

var player_slot_to_spawn
var _player

var npc_slot_to_spawn
var _npc


@onready var player_spawn_points = $player_spawn_points
@onready var enemy_spawn_points = $enemy_spawn_points

@onready var battle_control = $battle_control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func initialize(player: player_character, npc: npc_character):
	_player = player
	_npc = npc

	# TODO: Will need to look through NCP characters in json file to determine what prefabs to spawn
	# For now just initalize the first character
	player_slot_to_spawn =  player_spawn_points.get_child(1)
	player_slot_to_spawn.add_child(_player)
	_player.position = player_slot_to_spawn.position
	_player.set_state(Constants.CharacterStates.BATTLE)
	
	var spawn_index = _npc.get_battle_position()
	npc_slot_to_spawn = enemy_spawn_points.get_child(spawn_index)
	npc_slot_to_spawn.add_child(_npc)
	_npc.position = npc_slot_to_spawn.position
	_npc.rotation = 0
	_npc.move_direction = Constants.MoveDirection.WEST

	battle_control.initialize(_player)

func _process(delta):
	if Input.is_key_pressed(KEY_0):
		print("End Battle")
		end_battle()

# end the battle process by removing the player instance as a child and sending
# a signal back to the game manager
func end_battle():
	_player.set_state(Constants.CharacterStates.OVERWORLD)
	player_slot_to_spawn.remove_child(_player)
	npc_slot_to_spawn.remove_child(_npc)

	GameSceneManager.unload_battle_scene(_player, _npc)
