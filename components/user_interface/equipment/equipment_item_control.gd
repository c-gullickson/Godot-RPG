extends Control
class_name item_control

signal player_item_equip(item: item_data)
signal player_item_unequip(item: item_data)

@onready var item_label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/label_item_name
@onready var item_equip_checkbox = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/checkbox_item_equip
@onready var item_equip_button = $PanelContainer/MarginContainer/VBoxContainer/button_container/button_equip_item
@onready var item_unequip_button = $PanelContainer/MarginContainer/VBoxContainer/button_container/button_unequip_item

var _item: item_data = null
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Initialize the entire object to the container
func initialize_item(item: item_data):
	_item = item
	add_item_name(item.item_name)
	set_item_equip(item)
	
	
# Add a name to the item
func add_item_name(item_name: String):
	item_label.text = item_name


# Set the item equip state correctly
func set_item_equip(item: item_data):
	if item.is_item_equip:
		item_equip_checkbox.button_pressed = true
		item_equip_button.visible = false
		item_unequip_button.visible = true
	else:
		item_equip_checkbox.button_pressed = false
		item_equip_button.visible = true
		item_unequip_button.visible = false


# On Equip button pressed, toggle checkbox in corner, and hide equip button
func _on_button_equip_item_pressed():
	item_equip_checkbox.button_pressed = true
	item_equip_button.visible = false
	item_unequip_button.visible = true
	emit_signal("player_item_equip", _item)


# On Unequip button pressed, untoggle checkbox in corner, and hide unequip button
func _on_button_unequip_item_pressed():
	item_equip_checkbox.button_pressed = false
	item_equip_button.visible = true
	item_unequip_button.visible = false
	emit_signal("player_item_unequip", _item)
