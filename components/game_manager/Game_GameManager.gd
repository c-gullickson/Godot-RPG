extends Node

## Preloaded variables for Game
#var starting_level_scene_path = "res://scenes/LevelManager/Level1/level_1_cells_1.tscn"
#var current_level

#var battle_scene_preload = preload("res://scenes/LevelManager/Battle/battle_dungeon.tscn")
#var battle_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#player = player_preload.instantiate()
	#GameSceneManager.load_scene(starting_level_scene_path, player)
	
	#current_level = level_preload.instantiate()
	#add_child(current_level)
	#current_level.connect("trigger_battle", Callable(self, "_start_battle"))
	
	#player = player_preload.instantiate()
	#current_level.initialize(player)

# Transition from overworld state to battle state
#func _start_battle(player: player_character, npc: npc_character):
	#print("Game Start Battle")
	#
	## Set player overworld variables
	#current_level.visible = false
	#
	## Load battle variables
	#battle_scene = battle_scene_preload.instantiate()
	#add_child(battle_scene)
	#battle_scene.connect("battle_complete", Callable(self, "_end_battle"))
	#
	#battle_scene.initialize(player, npc)


# Transition from battle state back to overworld state
#func _end_battle(player: player_character, npc: npc_character):
	#current_level.set_player_in_overworld(player)
	#current_level.set_npc_in_overworld(npc)
	#
	#current_level.visible = true
	#battle_scene.queue_free()
