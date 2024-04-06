extends Control

class_name overworld_ui

signal equipment_control_closed()

var message_notification_preload = preload("res://scenes/UserInterface/message_notification.tscn")
var message_notification

var equipment_control_preload = preload("res://scenes/UserInterface/Battle/equipment_control.tscn")
var equipment_control: Control

func _ready():
	message_notification = message_notification_preload.instantiate()
	add_child(message_notification)
	message_notification.connect("all_messages_cleared", Callable(self, "close_message_notification"))
	message_notification.visible = false
		
	equipment_control = equipment_control_preload.instantiate()
	add_child(equipment_control)
	equipment_control.connect("close_equipment_control", Callable(self, "close_equipment_control"))
	equipment_control.visible = false
	
# Add a new overworld message
func add_message(message_text: String):
	message_notification.visible = true
	message_notification.add_message(message_text)
	
func remove_message():
	message_notification.remove_message()
	
func close_message_notification():
	message_notification.visible = false
	


func open_equipment_control(character_inventory: inventory):
	# populate the list of items
	equipment_control.initialize_items(character_inventory)
	
	# make control visible
	equipment_control.visible = true
	equipment_control.set_z_index(10)
	equipment_control.global_position = Vector2(576,0)


func close_equipment_control():
	equipment_control.visible = false
	emit_signal("equipment_control_closed")
