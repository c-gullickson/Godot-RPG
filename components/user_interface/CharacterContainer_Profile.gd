extends TextureRect

var LPCSpriteSheet = preload("res://addons/LPCAnimatedSprite/LPCSpriteSheet.gd")
var LPCSpriteType = preload("res://addons/LPCAnimatedSprite/LPCSpriteSheet.gd")
var Character_Spritesheet = preload("res://classes/Character_Spritesheet.gd")

@onready var character_selection = null
@onready var lpc_profile = $LPCAnimatedSprite2D

var selected_gender: String = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	_set_image()

# Set the gender of the character profile
func set_gender(gender):
	self.selected_gender = gender.to_lower()

# Define a character base, determined by the base path passed in
func add_character_base(new_sheet_path: String):
	var json_data = JsonLoader.load_json_by_path(new_sheet_path)
	
	var spritesheet_type = json_data["type_name"]
	var character_base_path = json_data["layer_1"][self.selected_gender] + json_data["variants"][0]
	var character_base_layer = json_data["layer_1"]["zPos"]
	add_sheet(spritesheet_type, character_base_path, character_base_layer)

func connect_signal(character_selection: ButtonData):
	self.character_selection = character_selection
	character_selection.connect("character_customization_changed", Callable(self, "add_sheet"))

# Using the file path of the selected part, append it to the LPC Array
func add_sheet(spritesheet_type: String, new_sheet_path: String, layer: int):
	
	lpc_profile.add_sheet(spritesheet_type, new_sheet_path, layer, null, "player" )
	_set_image()

# Private => set the texture of the character to the lpc_profile animated sprite 2d
func _set_image():
	# Load the image texture and set it to the TextureRect
	self.texture = lpc_profile
