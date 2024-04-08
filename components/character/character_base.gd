extends CharacterBody2D
class_name  character_base

const Constants = preload("res://components/constants/Enumerations.gd")

@export var speed = 200
@export var move_direction = Constants.MoveDirection.SOUTH
@export var _character_stats: character_stats = character_stats.new()

@onready var lpc_animator: LPCAnimatedSprite2D = $LPCAnimatedSprite2D
@onready var character_animation = $CharacterAnimationComponent

var follow_path
var should_follow_path: bool = false
var character_position: Vector2
var character_position_last: Vector2

func _ready():
	pass

func _process(delta):
	velocity = Vector2()
	
	if should_follow_path:
		if follow_path.progress_ratio < 1:
			follow_path.progress_ratio += 0.05 * delta
			character_position = follow_path.position
			character_position_last = follow_path.position
		else:
			character_position = Vector2()
	else:
		should_follow_path = false
	
	if follow_path:
		character_animation.modify_move_animation_by_pathfollow(character_position)

# using a dictionary value, apply character stats
func load_character_stats(character_json_stats: Dictionary):
	var class_stats = []
	var class_attributes = []
	for class_stat in character_json_stats["classStats"]:
		var new_class_stat = stat.new()
		new_class_stat.stat_type = class_stat["statType"]
		new_class_stat.stat_name = class_stat["statName"]
		new_class_stat.current_stat_value = class_stat["currentStatValue"]
		new_class_stat.max_stat_value = class_stat["maxStatValue"]
		class_stats.append(new_class_stat)
		
	for class_attribute in character_json_stats["classAttributes"]:
		var new_class_attribute = attribute.new()
		new_class_attribute.attribute_type = class_attribute["attributeType"]
		new_class_attribute.attribute_name = class_attribute["attributeName"]
		new_class_attribute.attribute_value = class_attribute["attributeValue"]
		class_attributes.append(new_class_attribute)
		
	_character_stats.stats_list = class_stats
	_character_stats.attributes_list = class_attributes

# set character stats based on an existing character_stats resource
func set_character_stats(applied_character_stats: character_stats):
	_character_stats = applied_character_stats


# Allow for path follow movement
func start_follow_path():
	print("Starting NPC Follow Path")
	should_follow_path = true
	follow_path = get_parent()
	
# Tell the NPC to stop following the path, but not to reset
func pause_follow_path():
	should_follow_path = false
	follow_path = null
