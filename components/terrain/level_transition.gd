extends Area2D

const Constants = preload("res://components/constants/Enumerations.gd")

@export var room_name_path: String
@export_enum("level_transition_north", "level_transition_east", "level_transition_south", "level_transition_west" ) var room_transition_point: String
@export_enum("north", "east", "south", "west") var transition_direction: String

var has_entered: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Listen for when the player enters the transition
func _on_body_entered(body):
	if "Player" not in body.name:
		return

	if has_entered == false:
		var transition = overworld_transition.new()
		transition.room_entry_point = room_transition_point
		transition.transition_direction = transition_direction
		
		body.set_transition(transition)
		GameSceneManager.load_scene_overworld(room_name_path, body)
		has_entered = true
