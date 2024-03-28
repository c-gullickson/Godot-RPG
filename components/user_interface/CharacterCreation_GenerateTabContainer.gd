extends TabContainer

var CharacterClassButton = "res://classes/CharacterClassButton.gd"
@onready var character_container_profile = $"../../CharacterContainer/MarginContainer/VBoxContainer/ProfileTextureRect"

var selected_gender = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Set the gender of the character profile
func set_gender(gender):
	self.selected_gender = gender.to_lower()

# Create a new tab to hold all of the sub part options
func create_new_part_tab_container(character_part: Dictionary):
	
	# Create a new VBoxContainer
	var newTabContainer = VBoxContainer.new()
	newTabContainer.name = character_part["containerText"]
	add_child(newTabContainer)
	for container in character_part["containerTypes"]:
		_create_new_part_container(container, newTabContainer)

# Iterate through all of the sub part options to create new "rows" for each
func _create_new_part_container(subtype_container: Dictionary, parent_tab: VBoxContainer):
	# Create a new VBoxContainer
	var new_container = VBoxContainer.new()
	new_container.name = subtype_container["subtypeText"]
	
	var grid_container = GridContainer.new()
	grid_container.columns = 3
	
	var label = Label.new()
	label.text = subtype_container["subtypeText"]
	
	var subtype_path = subtype_container["subtypePath"]	
	var json_data = JsonLoader.load_json_by_path(subtype_path)
	
	# Instantiate the next / previous buttons for each option
	var button_data = ButtonData.new(json_data, selected_gender)
	character_container_profile.connect_signal(button_data);
	
	var next_button = _create_button("Next", button_data)
	next_button.connect("pressed", Callable(button_data, "on_click_next"))

	var previous_button = _create_button("Previous", button_data)
	previous_button.connect("pressed", Callable(button_data, "on_click_previous"))

	# Apply the buttons / labels into a grid layout group container
	grid_container.add_child(label)
	grid_container.add_child(next_button)
	grid_container.add_child(previous_button)
	
	# Add the Label to the VBoxContainer
	new_container.add_child(grid_container)
	
	# Append container to tab
	parent_tab.add_child(new_container)
	
# Instantiate a new button option for next or previous functionality
func _create_button(button_name: String, button_data: ButtonData) -> Button:
	var button = Button.new()
	button.name = button_name
	button.text = button_name
	button.add_child(button_data)
	
	return button
