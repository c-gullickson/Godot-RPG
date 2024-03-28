extends Resource

class_name item_data

enum ItemType { KEY, WEAPON, MAGIC, POTION }

@export var item_type: ItemType
@export var item_name: String
@export_multiline var item_description: String
@export var item_texture: Texture2D
@export var item_weight: float
@export var item_is_equipable: bool
