extends PanelContainer

@onready var gender_selection = $MarginContainer/VBoxContainer/CharacterGender/GenderOptionButton
@onready var class_selection = $MarginContainer/VBoxContainer/CharacterClass/ClassOptionButton

@onready var _character_tab_container = $"../CharacterCustomContainer/TabContainer"
@onready var _character_container_profile = $MarginContainer/VBoxContainer/ProfileTextureRect


@onready var _class_file_base_path = "res://Assets/class_definitions/character_generation/"

var _selected_gender = ""
var _selected_class = ""

var _class_file_path: String = ""
var _character_creation_data: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	gender_selection.connect("gender_selection_changed", Callable(self, "_on_gender_option_button_gender_selection_changed"))
	class_selection.connect("class_selection_changed", Callable(self, "_on_class_option_button_class_selection_changed"))

# When the gender has been changed, reload the character base
func _on_gender_option_button_gender_selection_changed(selected_index, selected_value):
	print("On Gender Select " + str(selected_value))
	_selected_gender = selected_value
	_character_container_profile.set_gender(_selected_gender)
	_character_tab_container.set_gender(_selected_gender)
	if _selected_class != "":
		_load_character_creation_file()

# When the class has been changed, reload the character base
func _on_class_option_button_class_selection_changed(selected_index, selected_value):
	print("On Class Select " + str(selected_value))
	_selected_class = selected_value
	
	_class_file_path = "%s/%s/%s/characterCreation.json" % [_class_file_base_path, _selected_class, _selected_gender ]
	if _selected_gender != "":
		_load_character_creation_file()

# Load in and parse out Character Data class/gender file
func _load_character_creation_file():
	_character_creation_data = JsonLoader.load_json_by_path(_class_file_path)
	if _character_creation_data is Dictionary:
		_parse_character_creation_data()
	else:
		print("Invalid File Format")

# Take the Chracter Data class/gender file, and parse it
# Set the base character stats based on the class
# Initialize a new tab for each part type 
func _parse_character_creation_data():
	var creation_data = _character_creation_data["characterCreation"]
	_character_container_profile.add_character_base(creation_data["body"])
	CharacterLoader.set_character_stats(creation_data["characterStats"])
	# Sort through the list of character parts
	for character_part in creation_data["partType"]:
		# Generate a new Container
		_character_tab_container.create_new_part_tab_container(character_part)
