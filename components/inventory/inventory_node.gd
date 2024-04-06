extends Node
class_name inventory

var _items: Array = []
var _lpcAnimator: LPCAnimatedSprite2D
var _character_type: String

# Create a new initialization of the inventory
func initialize(animator: LPCAnimatedSprite2D, character_type: String):
	_lpcAnimator = animator
	_character_type = character_type

# Get all items, return as an array
func get_all_items():
	return _items


# Add an item
func add_item(item: item_data, quantity: int):
	print("Add Item to Inventory")
	for x in quantity:
		_items.append(item)


func equip_item_in_inventory(item: item_data):
	var item_index = _items.find(item)
	var inventory_item: item_data = _items[item_index]
	inventory_item.is_item_equip = true
	
	_lpcAnimator.add_sheet(str(item.item_type), "", item.item_z_position, item.item_texture, _character_type)


func unequip_item_in_inventory(item: item_data):
	var item_index = _items.find(item)
	var inventory_item: item_data = _items[item_index]
	inventory_item.is_item_equip = false
	
	_lpcAnimator.remove_sheet(str(item.item_type), item.item_z_position, _character_type)

# Pass the name the item to look for in the current inventory
func check_inventory_for_item(item_to_check: String) -> bool:
	var has_item = false
	
	for item in _items:
		if item.item_name == item_to_check:
			print("Inventory has item: " + str(item))
			has_item = true
	
	return has_item
