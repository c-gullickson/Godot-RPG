extends Control

class_name Character_Spritesheet

var spritesheet_type: String
var spritesheet: LPCSpriteSheet
var spritesheet_layer: int


func _init(spritesheet_type: String, spritesheet: LPCSpriteSheet, spritesheet_layer: int):
	self.spritesheet_type = spritesheet_type
	self.spritesheet = spritesheet
	self.spritesheet_layer = spritesheet_layer
