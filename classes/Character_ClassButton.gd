extends Control

class_name ButtonData

signal character_customization_changed(type, path, zpos)

var button_data: Dictionary
var direction: int
var gender: String

var current_index = -1

# Initialize the button with the specific part and gender
func _init(data: Dictionary, gender: String):
	self.button_data = data
	self.gender = gender
	
	_assign_next_variant()

# Assign the next variant sprite in the list of variants
func on_click_next():
	print("button clicked next")
	current_index += 1
	_assign_next_variant()

# Assign the previous variant sprite in the list of variants
func on_click_previous():
	print("button clicked previous")
	current_index -= 1
	_assign_next_variant()

# Generate the spritesheet path for the variant based on the index.
func _assign_next_variant():
	var spritesheet_variant = button_data["variants"][current_index]
	print("Data: " + spritesheet_variant )
	
	var spritesheet_type = button_data["type_name"]
	var spritesheet_path = button_data["layer_1"][gender.to_lower()] + spritesheet_variant
	var spritesheet_zpos = button_data["layer_1"]["zPos"]
	print("Path: " + spritesheet_path)
	
	emit_signal("character_customization_changed", spritesheet_type, spritesheet_path, spritesheet_zpos)
