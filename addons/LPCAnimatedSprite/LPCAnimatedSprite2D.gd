@tool
extends Node2D

class_name LPCAnimatedSprite2D

@export var SpriteSheets:Array[LPCSpriteSheet]
@export var DefaultAnimation:LPCAnimation = LPCAnimation.IDLE_DOWN

var assigned_spritesheets: Array = []

enum LPCAnimation {
	CAST_UP,
	CAST_LEFT,
	CAST_DOWN,
	CAST_RIGHT,
	THRUST_UP,
	THRUST_LEFT,
	THRUST_DOWN,
	THRUST_RIGHT,
	WALK_UP,
	WALK_LEFT,
	WALK_DOWN,
	WALK_RIGHT,
	SLASH_UP,
	SLASH_LEFT,
	SLASH_DOWN,
	SLASH_RIGHT,
	SLASH_REVERSE_UP,
	SLASH_REVERSE_LEFT,
	SLASH_REVERSE_DOWN,
	SLASH_REVERSE_RIGHT,
	SHOOT_UP,
	SHOOT_LEFT,
	SHOOT_DOWN,
	SHOOT_RIGHT,
	HURT_DOWN,
	IDLE_UP,
	IDLE_LEFT,
	IDLE_DOWN,
	IDLE_RIGHT,
	HURT_DOWN_LAST
}
var AnimationNames:Array
func _ready():
	if Engine.is_editor_hint() == false:
		LoadAnimations()

# Add a specific layer to the current layers available.
# If layer exists, update
# Sort and reapply all spritesheets
func add_player_spritesheet_layer(lpc_character_spritesheet: Character_Spritesheet):
	spritesheet_exists_index(lpc_character_spritesheet)
	
	SpriteSheets.clear()
	for spritesheet in sort_spritesheets_by_layer(assigned_spritesheets):
		SpriteSheets.append(spritesheet.spritesheet)

	LoadAnimations()
	CharacterLoader.set_character_spritesheet_profile(assigned_spritesheets)

# Apply a new spritesheet layer for any npc character
# Separate method due to not needing to save a character profile
func add_npc_spritesheet_layer(npc_lpc_character_spritesheet: Character_Spritesheet):
	spritesheet_exists_index(npc_lpc_character_spritesheet)
	
	SpriteSheets.clear()
	for spritesheet in sort_spritesheets_by_layer(assigned_spritesheets):
		SpriteSheets.append(spritesheet.spritesheet)
		
	LoadAnimations()
	
# Using a dictionary of sprite parts, create a character
func add_spritesheet_profile(spritesheet_profile: Array):
	assigned_spritesheets = spritesheet_profile
	var sorted_spritesheets : Array = sort_spritesheets_by_layer(assigned_spritesheets)
	SpriteSheets.clear()
	
	for spritesheet in sorted_spritesheets:
		SpriteSheets.append(spritesheet.spritesheet)
		
	LoadAnimations()

func play(animation: LPCAnimation, fps: float = 5.0):
	var sprites = get_children() as Array[AnimatedSprite2D]
	for sprite in sprites:
		if sprite.sprite_frames.has_animation(AnimationNames[animation]):
			sprite.visible = true
			sprite.sprite_frames.set_animation_speed(AnimationNames[animation], fps)
			sprite.play(AnimationNames[animation])
		else:
			sprite.visible = false

func _notification(what):
	if what == NOTIFICATION_EDITOR_POST_SAVE:
		call_deferred("LoadAnimations")
		
func _enter_tree():
	if Engine.is_editor_hint():
		LoadAnimations()
	
func LoadAnimations():
	AnimationNames = LPCAnimation.keys()
	var children = get_children();
	for child in children:
		remove_child(child)
		
	for spriteSheet in SpriteSheets:
		if spriteSheet == null:
			push_warning("There are LPCSpriteSheets that are <empty> in the LPCAnimatedSprite2D panel")
			continue
		var animatedSprite = AnimatedSprite2D.new()
		animatedSprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		var spriteFrames = CreateSprites(spriteSheet)
		animatedSprite.frames = spriteFrames
		add_child(animatedSprite)
		if spriteSheet.Name == null || spriteSheet.Name == "":
			animatedSprite.name = "no_name"
		else:
			animatedSprite.name = spriteSheet.Name
		animatedSprite.owner = get_tree().edited_scene_root
		play(DefaultAnimation)

func CreateSprites(spriteSheet:LPCSpriteSheet):
	var spriteFrames = SpriteFrames.new()
	spriteFrames.remove_animation("default")
	
	for animationData in spriteSheet.AnimationData():
		AddAnimation(spriteSheet, spriteFrames, animationData)
	return spriteFrames

func AddAnimation(spriteSheet:LPCSpriteSheet, spriteFrames:SpriteFrames, animationData:LPCAnimationData):
	if spriteSheet == null || spriteSheet.SpriteSheet == null:
		return
	
	if spriteFrames.has_animation(animationData.Name):
		spriteFrames.remove_animation(animationData.Name)
		
	spriteFrames.add_animation(animationData.Name)
	var frameStart = animationData.FrameCount -1 if animationData.Reverse else animationData.Col
	var frameEnd = animationData.Col -1 if animationData.Reverse else animationData.FrameCount
	var reversed = -1 if animationData.Reverse else 1
	for frame in range(frameStart, frameEnd , reversed):
		var atlasTexture = AtlasTexture.new()
		atlasTexture.atlas = spriteSheet.SpriteSheet
		atlasTexture.region = spriteSheet.GetSpriteRect(animationData, frame)
		spriteFrames.add_frame(animationData.Name, atlasTexture, 0.5)
	spriteFrames.set_animation_loop(animationData.Name, animationData.Loop)
	return spriteFrames


# Function to sort the list of current spritesheets by the 'sortValue' property
func sort_spritesheets_by_layer(spritesheets : Array) -> Array:
	# Sort the based on the 'sortValue' property of the custom objects
	spritesheets.sort_custom(Callable(self, "sort_spritesheets"))
	
	return spritesheets

# Custom comparison function for sorting based on 'sortValue'
func sort_spritesheets(a:Character_Spritesheet , b: Character_Spritesheet) -> bool:
	if a.spritesheet_layer < b.spritesheet_layer:
		return true
	return false

# Iterate through the list of existing spritesheets assigned, and determine if the type already exists
# If it already exists, then update and replace
# Else append to the assigned spritesheet array
func spritesheet_exists_index(lpc_character_spritesheet: Character_Spritesheet) -> void:
	var index = 0
	for assigned_spritesheet: Character_Spritesheet in assigned_spritesheets:
		if assigned_spritesheet.spritesheet_type == lpc_character_spritesheet.spritesheet_type:
				
			assigned_spritesheets.remove_at(index)
			assigned_spritesheets.append(lpc_character_spritesheet)
			return
		else:
			index += 1
	
	assigned_spritesheets.append(lpc_character_spritesheet)
	return
