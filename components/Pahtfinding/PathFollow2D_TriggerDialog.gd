extends Node2D

signal trigger_dialog();

# Called when the Rogue NPC enters the trigger box to start the dialog
func _on_area_2d_body_entered(body):
	if "character_rogue" in body.name:
		emit_signal("trigger_dialog")
