extends Control

@onready var message_text = $message_text
var message_duration: float = 4


func _ready():
	pass

func _initialize():
	pass
	
func add_message(message: String):
	message_text.text = message

# Apply a duration to the message, and have it be removed after it's time
func _process(delta):
	message_duration -= delta
	
	if(message_duration <= 0):
		OverworldUi.remove_message()
		queue_free()
