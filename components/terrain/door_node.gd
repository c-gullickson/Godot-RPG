extends Node2D

@export var key_type_required: String

var player: player_character
	
# determine the interaction between player and door
func _on_area_2d_body_entered(body: Node2D):
	# Only listen for Player collision
	if "Player" in body.name:
		player = body
		print("The Door is Locked")
		var has_key = _check_player_for_key(key_type_required)
		
		if has_key:
			_open_door()
		else:
			print("Missing Key ")

# Check the character to determine if the correct key is in the inventory
func _check_player_for_key(key_type_required: String) -> bool:
	var has_key = player.check_items_in_inventory(key_type_required)
	return has_key

# Remove the door as it is know open
func _open_door():
	queue_free()
