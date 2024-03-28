extends Node2D

signal cutscene_complete()

@onready var rogue = $Path2D/PathFollow2D/character_rogue
@onready var rouge_cutscene_trigger = $PathFollow2D_TriggerDialog
@onready var rogue_path_follow = $Path2D/PathFollow2D

func _ready():
	# Listen for the rogue to enter the dialog area for triggering the initial cutscene
	rouge_cutscene_trigger.connect("trigger_dialog", Callable(self, "_trigger_dialog"))
	Dialogic.timeline_ended.connect(Callable(self, "_dialog_complete"))

func _process(delta):
	if rogue_path_follow.progress_ratio == 1:
		end_cutscene()


# Listen for when the player enters the cutscene trigger box
func start_cutscene():
	print("Starting Cutscene")
	rogue.start_follow_path()


# Listen for when the cutscene is completely over
func end_cutscene():
	print("Ending Cutscene")
	cutscene_complete.emit()


# Trigger the introduction between the player and the rogue
func _trigger_dialog():
	# Pause the character and display the dialog
	rogue.pause_follow_path()
	# Invoke the dialog
	var introduction_timeline = Dialogic.start("introduction_rogue")


func _dialog_complete():
	rogue.start_follow_path()
	Dialogic.timeline_ended.disconnect(_dialog_complete)
	
