extends Node
class_name inventory

var items: Array = []

# Create a new initialization of the inventory
func initialize():
	pass
	
# Add an item
func add_item(item: item_data, quantity: int):
	print("Add Item to Inventory")
	for x in quantity:
		items.append(item)


# Pass the name the item to look for in the current inventory
func check_inventory_for_item(item_to_check: String) -> bool:
	var has_item = false
	
	for item in items:
		if item.item_name == item_to_check:
			print("Inventory has item: " + str(item))
			has_item = true
	
	return has_item
