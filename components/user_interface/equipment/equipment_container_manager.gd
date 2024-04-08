extends MarginContainer

class_name equipment_container_manager

enum ItemCategory { KEY=0, WEAPON=1, MAGIC=2, POTION=3, CLOTHING=4, ARMOR=5 }
var item_list_data_container_preload = preload("res://scenes/UserInterface/Battle/equipment_item_control.tscn")

@onready var equipment_tab_container: TabContainer = $TabContainer

func _ready():
	pass


func add_item_to_container(item: item_data):
	if item.item_category == ItemCategory.CLOTHING:
		print("Add CLOTHING")
		var clothes_container = equipment_tab_container.find_child("clothes_container")
		var clothing_items = clothes_container.find_child("clothes_items")
		var data_container = item_list_data_container_preload.instantiate()
		data_container.name = "item_" + str(item.item_name)
		clothing_items.add_child(data_container)
		
		data_container.initialize_item(item)

