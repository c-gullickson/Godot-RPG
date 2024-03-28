extends Node2D
class_name Character_CharacterAnimationComponent

const Constants = preload("res://components/constants/Enumerations.gd")

var character_animation = null
var last_position: Vector2
var move_direction = Constants.MoveDirection.SOUTH

func initialize(lpc_animator: LPCAnimatedSprite2D):
	character_animation = lpc_animator

# Calculate the NPC moving along a path, 
# based on it's current and cached positions on the path
func modify_move_animation_by_pathfollow(position: Vector2):
	var velocity = (position - last_position).normalized()
	if velocity.x == 1:
		move_direction = Constants.MoveDirection.EAST
	if velocity.x == -1:
		move_direction = Constants.MoveDirection.WEST
	if velocity.y == 1:
		move_direction = Constants.MoveDirection.SOUTH
	if velocity.y == -1:
		move_direction = Constants.MoveDirection.NORTH
	
	modify_move_animation(velocity, move_direction)
	last_position = position
	
func modify_move_animation(velocity, move_dir):
	if velocity == Vector2.ZERO:
		match move_dir:
			Constants.MoveDirection.NORTH:
				character_animation.play(LPCAnimatedSprite2D.LPCAnimation.IDLE_UP)
			Constants.MoveDirection.SOUTH:
				character_animation.play(LPCAnimatedSprite2D.LPCAnimation.IDLE_DOWN)
			Constants.MoveDirection.EAST:
				character_animation.play(LPCAnimatedSprite2D.LPCAnimation.IDLE_RIGHT)
			Constants.MoveDirection.WEST:
				character_animation.play(LPCAnimatedSprite2D.LPCAnimation.IDLE_LEFT)
	else:
		match move_dir:
			Constants.MoveDirection.NORTH:
				character_animation.play(LPCAnimatedSprite2D.LPCAnimation.WALK_UP)
			Constants.MoveDirection.SOUTH:
				character_animation.play(LPCAnimatedSprite2D.LPCAnimation.WALK_DOWN)
			Constants.MoveDirection.EAST:
				character_animation.play(LPCAnimatedSprite2D.LPCAnimation.WALK_RIGHT)
			Constants.MoveDirection.WEST:
				character_animation.play(LPCAnimatedSprite2D.LPCAnimation.WALK_LEFT)

func set_dead_animation():
	character_animation.play(LPCAnimatedSprite2D.LPCAnimation.HURT_DOWN)
