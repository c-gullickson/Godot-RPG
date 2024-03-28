extends Node2D

var debug = true

var _player
var player_overworld_position: Vector2
var npc_overworld_position: Vector2

@onready var player_spawn_position: Node2D = $cells_1/player_starting_spawn

# Introduction Cutscene
@onready var introduction_cutscene_trigger: Node2D = $cells_1/introduction_cutscene_trigger
@onready var introduction_cutscene_preload = preload("res://components/cutscenes/level1/cutscene_introduction.tscn")
@onready var introduction_cutscene
var opening_cutscene_played: bool = false

# Guard Interaction Cutscene
@onready var interaction_guard_cutscene_trigger: Node2D = $cells_1/interaction_guard_cutscene_trigger_trigger
@onready var interaction_guard_cutscene_preload = preload("res://components/cutscenes/level1/cutscene_guard_interaction.tscn")
@onready var interaction_guard_cutscene
var guard_interaction_cutscene_played: bool = false

@onready var level_transitions = $cells_1/level_transitions
var level_transition_dictionary: Dictionary = {}

@onready var cell_key = load("res://components/inventory/items/cell_key.tres")
@onready var rusty_dagger = load("res://components/inventory/items/weapons/rusty_dagger.tres")

var player_has_starting_objects: bool = false

func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.timeline_ended.connect(Callable(self, "_dialog_complete"))
	
	for transition in level_transitions.get_children():
		level_transition_dictionary[transition.name] = transition.get_child(1)


func initialize_player_overworld(player: player_character):
	# Spawn the player into the level
	_player = player
	_instantiate_player()
	
	if debug: _give_player_starting_objects()


func _on_dialogic_signal(argument: String):
	if argument == "give_starting_objects":
		_give_player_starting_objects()


# Listen for initial dialog to be complete
func _dialog_complete():
	Dialogic.timeline_ended.disconnect(_dialog_complete)
	# TODO: Try to get the initial cutscene trigger to enable after the first dialog is complete


# Load the player into the game
func _instantiate_player():
	print("Loading Player")
	add_child(_player)
	
	if _player.player_overworld_transition == null:
		_player.instantiate_new_player()
		_player.position = player_spawn_position.position
	else:
		var player_entry_point = _player.player_overworld_transition.room_entry_point
		var player_spawn_point = level_transition_dictionary[player_entry_point]
		_player.position = player_spawn_point.global_position
	
	# Invoke the dialog
	if !debug:
		var introduction_timeline = Dialogic.start("player_awakening")

# Bring the player back into the overworld after a battle
# TODO: possibly use as a save?
func set_player_in_overworld(player: player_character):
	add_child(player)
	player.position = player_overworld_position
	player.set_can_use_player_input(true)

# Add the npc character back into the overworld and assign as a dead target
func set_npc_in_overworld(npc: npc_character):
	add_child(npc)
	npc.position = npc_overworld_position
	npc.set_is_dead(true)
	

# Create a trigger for when the player enters, a cutscene starts
# Will set a flag indicating the scene has already played.
func _on_area_2d_body_entered(body):
	# Only listen for Player collision
	if debug:
		return
		
	if "Player" in body.name:
		if !opening_cutscene_played:
			print("Start intro cutscene")
			_player.set_can_use_player_input(false)
			opening_cutscene_played = true
			
			introduction_cutscene = introduction_cutscene_preload.instantiate()
			add_child(introduction_cutscene)
			introduction_cutscene.start_cutscene()
			introduction_cutscene.connect("cutscene_complete", Callable(self, "_introduction_cutscene_complete"))
		else: 
			print("Cutscene Already Played")


# Give the player the cell key to open the door
func _give_player_starting_objects():
	if not player_has_starting_objects:
		# TODO: Create a specific json file to load items
		_player.add_item_to_inventory(cell_key, 1)
		_player.add_item_to_inventory(rusty_dagger, 1)
		player_has_starting_objects = true


func _introduction_cutscene_complete():
	_player.set_can_use_player_input(true)
	introduction_cutscene_trigger.queue_free()
	introduction_cutscene.queue_free()


func _on_interaction_guard_cutscene_trigger_body_entered(body):
	# Only listen for Player collision
	if "Player" in body.name:
		if !guard_interaction_cutscene_played:
			_player.set_can_use_player_input(false)
			print("Start guard interaction cutscene")
			guard_interaction_cutscene_played = true
			
			interaction_guard_cutscene = interaction_guard_cutscene_preload.instantiate()
			add_child(interaction_guard_cutscene)
			interaction_guard_cutscene.start_cutscene()
			
			# Will need to be able to pass back an npc_character object
			interaction_guard_cutscene.connect("guard_interaction_cutscene_complete", Callable(self, "_trigger_battle"))


# Clear the cutscene components, and invoke a battle
func _trigger_battle(npc: npc_character, npc_position: Vector2):
	interaction_guard_cutscene_trigger.queue_free()
	interaction_guard_cutscene.queue_free()
	
	player_overworld_position = _player.position
	npc_overworld_position = npc_position
	
	remove_child(_player)
	GameSceneManager.load_battle_scene(_player, npc)
