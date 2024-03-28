##
# Spawn a guard after the player has gotten out of their cell and is almost out of the section.
# Invoke a dialog section after the player has triggered the cutscene
# 
##
extends Node2D

signal guard_interaction_cutscene_complete(npc: npc_character, npc_position: Vector2)

@onready var guard = $Path2D/PathFollow2D/character_dungeon_guard_1
@onready var guard_path_follow = $Path2D/PathFollow2D
@onready var guard_path_end = $end_position_dungeon_guard_1

var dialog_triggered: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# Listen for the rogue to enter the dialog area for triggering the initial cutscene
	Dialogic.timeline_ended.connect(Callable(self, "_dialog_complete"))


func _process(delta):
	if !dialog_triggered:
		if guard_path_follow.progress_ratio == 1:
			_trigger_dialog()


# Listen for when the player enters the cutscene trigger box
func start_cutscene():
	print("Starting Guard Interaction Cutscene")
	guard.start_follow_path()


# Trigger the introduction between the player and the rogue
func _trigger_dialog():
	# Invoke the dialog
	dialog_triggered = true
	var introduction_timeline = Dialogic.start("interaction_guard_1")


# Trigger once the dialog has been completed
func _dialog_complete():
	Dialogic.timeline_ended.disconnect(_dialog_complete)
	guard.pause_follow_path()
	end_cutscene()


# When the cutscene is completely over, trigger back to the level manager
# Pass back the guard's data to iinvoke a battle from this cutscene
func end_cutscene():
	print("Ending Cutscene")
	guard_path_follow.remove_child(guard)
	guard_interaction_cutscene_complete.emit(guard, guard_path_end.global_position)
