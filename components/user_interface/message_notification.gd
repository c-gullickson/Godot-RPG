extends PanelContainer

var message_preload = preload("res://scenes/UserInterface/message.tscn")
var message_queue = []

signal all_messages_cleared()

var message_v_container: VBoxContainer

func _ready():
	message_v_container = VBoxContainer.new()
	add_child(message_v_container)

# Add a new message to te UI dialog
func add_message(message_text: String):
	# Append a new message object to the message notificaition UI
	var message = message_preload.instantiate()
	message_v_container.add_child(message)
	message.add_message(message_text)
	message_queue.push_back(message)

# Remove a message from the queue
func remove_message():
	message_queue.pop_front()
	if get_child_count() == 0:
		emit_signal("all_messages_cleared")
