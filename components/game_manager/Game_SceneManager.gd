extends Node
class_name scene_managager

var game
var outgoing_scene
var incoming_scene

var battle_scene_preload = preload("res://scenes/LevelManager/Battle/battle_dungeon.tscn")
var battle_scene

var _load_progress_timer
var _scene_path
var _player

func load_scene_auto(scene_path: String):
	outgoing_scene = get_tree().current_scene
	print("Loading Scene: " + scene_path)
	incoming_scene = load(scene_path)
	
	get_tree().change_scene_to_packed(incoming_scene)
	

func load_scene_overworld(scene_path: String, player: player_character):
	_player = player
	_scene_path = scene_path
	var resource_loader = ResourceLoader.load_threaded_request(_scene_path)
		
	_load_progress_timer = Timer.new()
	_load_progress_timer.wait_time = 0.2
	_load_progress_timer.timeout.connect(monitor_load_status)
	get_tree().root.add_child(_load_progress_timer)
	_load_progress_timer.start()

# Load in the battle scene
func load_battle_scene(player: player_character, npc: npc_character):
	print("Start Battle Scene")

	outgoing_scene = get_tree().current_scene
	outgoing_scene.visible = false
	battle_scene = battle_scene_preload.instantiate()
	
	get_tree().root.add_child(battle_scene)
	battle_scene.initialize(player, npc)


# Unload the battle scene to the previous overworld scene
func unload_battle_scene(player: player_character, npc: npc_character):
	get_tree().root.remove_child(battle_scene)
	
	outgoing_scene.set_player_in_overworld(player)
	outgoing_scene.set_npc_in_overworld(npc)
	outgoing_scene.visible = true

func monitor_load_status() -> void:
	var load_progress = []
	var load_status = ResourceLoader.load_threaded_get_status(_scene_path, load_progress)
	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			_load_progress_timer.stop()
			print("Invalid Resource")
			return
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			print("Content Loaded: " + str(load_progress[0] * 100))
			return
		ResourceLoader.THREAD_LOAD_FAILED:
			_load_progress_timer.stop()
			print("Thread Load Failed")
			return
		ResourceLoader.THREAD_LOAD_LOADED:
			print("Content Loaded")
			_load_progress_timer.stop()
			_load_progress_timer.queue_free()
			content_loaded(ResourceLoader.load_threaded_get(_scene_path).instantiate())
			return

# Add newly loaded scene to parent
func content_loaded(content_scene):
	outgoing_scene = get_tree().current_scene
	outgoing_scene.remove_child(_player)
	
	get_tree().root.add_child(content_scene)
	get_tree().set_current_scene(content_scene)
	if content_scene.has_method("initialize_player_overworld"):

		content_scene.initialize_player_overworld(_player)
	
	outgoing_scene.queue_free()
	
