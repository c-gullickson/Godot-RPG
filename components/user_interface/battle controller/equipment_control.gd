extends Control
class_name equipment_controller

signal close_equipment_control()

var item_list_data_container_preload = preload("res://scenes/UserInterface/Battle/equipment_item_control.tscn")

@onready var items_container: VBoxContainer = $PanelContainer/VBoxContainer/HBoxContainer/items_container/VBoxContainer/ScrollContainer/items

var _items_container_list: Array = []
var _character_inventory: inventory

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Create the list of item containers
func initialize_items(character_inventory: inventory):
	# Remove an existing containers
	for item_container in _items_container_list:
		if item_container != null:
			item_container.queue_free()
	_items_container_list.clear()
	
	# Initialize inventory
	_character_inventory = character_inventory
	
	var item_index = 0
	for item: item_data in _character_inventory.get_all_items():
		var item_list_data_container: item_control = item_list_data_container_preload.instantiate()
		item_list_data_container.name = "item_" + str(item_index)
		items_container.add_child(item_list_data_container)
		
		item_list_data_container.initialize_item(item)
		item_list_data_container.connect("player_item_equip", Callable(self, "equip_item_to_character"))
		item_list_data_container.connect("player_item_unequip", Callable(self, "unequip_item_to_character"))
		
		_items_container_list.append(item_list_data_container)
		item_index += 1
	

func _on_container_button_close_pressed():
	print("Close equipment container")
	emit_signal("close_equipment_control")


# Delegate the action of equiping the item to the player
func equip_item_to_character(item: item_data):
	_character_inventory.equip_item_in_inventory(item)
	

func unequip_item_to_character(item: item_data):
	_character_inventory.unequip_item_in_inventory(item)

