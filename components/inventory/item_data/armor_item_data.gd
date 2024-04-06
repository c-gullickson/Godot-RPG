extends item_data

class_name armor_item_data

enum ArmorType { HELMET, SHOULDERS, CHEST, LEGS, BOOTS  }
enum ArmorItemVariationPrefix {OLD_LEATHER, WORN_LEATHER, TREATED_LEATHER, RUSTY_CHAINMAIL, HARDENED_CHAINMAIL}

@export var armor_type: ArmorType
@export var item_variation: ArmorItemVariationPrefix
@export var damage_resistance: float
