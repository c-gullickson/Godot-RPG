extends Control


var equipment_selection_preload = preload("res://scenes/UserInterface/Battle/equipment_control.tscn")
var equipment_selection


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Open the container to allow the player to equip different items for battle
func _on_player_equipment_button_pressed():
	equipment_selection = equipment_selection_preload.instantiate()
	add_child(equipment_selection)
	
	equipment_selection.connect("close_equipment_control", Callable(self, "close_equipment_control"))
	equipment_selection.global_position = Vector2(0,0)

func close_equipment_control():
	equipment_selection.queue_free()
