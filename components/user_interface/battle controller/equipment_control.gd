extends Control
class_name equipment_controller

signal close_equipment_control()

var item_list_data_container_preload = preload("res://scenes/UserInterface/Battle/equipment_item_control.tscn")

@onready var items_container: VBoxContainer = $PanelContainer/VBoxContainer/HBoxContainer/items_container/VBoxContainer/ScrollContainer/items
var items_list: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Create the list of item containers
func initialize_items(items: Array):
	var item_index = 0
	for item: item_data in items:
		var item_list_data_container: item_control = item_list_data_container_preload.instantiate()
		item_list_data_container.name = "item_" + str(item_index)
		items_container.add_child(item_list_data_container)
		
		item_list_data_container.initialize_item(item)
		
		items_list.append(item_list_data_container)
		item_index += 1
	

func _on_container_button_close_pressed():
	print("Close equipment container")
	emit_signal("close_equipment_control")
