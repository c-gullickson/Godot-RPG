extends Control
class_name item_control

@onready var item_label = $PanelContainer/MarginContainer/VBoxContainer/label_item_name

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Initialize the entire object to the container
func initialize_item(item: item_data):
	add_item_name(item.item_name)
	
	
# Add a name to the item
func add_item_name(item_name: String):
	item_label.text = item_name
