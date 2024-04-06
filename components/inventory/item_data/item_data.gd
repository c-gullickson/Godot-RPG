extends Resource

class_name item_data

enum ItemCategory { KEY, WEAPON, MAGIC, POTION, CLOTHING, ARMOR }
enum ItemType { CAPE, 
FEET, 
LEGS, 
DRESS, 
SKIRT, 
TORSO, 
APRON, 
VEST, 
CHAINMAIL, 
JACKET, 
ARMS, 
SHOULDERS,
BAULDRON, 
WAIST, 
BRACERS, 
GLOVES, 
WRISTS, 
NECK, 
SHIELD, 
HAT, 
HELMET, 
VISOR, 
ARMORED_HELMET, 
HAT_ACCESSORY, 
WEAPON }

@export var item_category: ItemCategory
@export var item_name: String
@export_multiline var item_description: String
@export var item_texture: Texture2D
@export var item_type: ItemType
@export var item_z_position: int
@export var item_weight: float
@export var item_is_equipable: bool
@export var is_item_equip: bool
