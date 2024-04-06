extends item_data

class_name weapon_item_data

enum AttackType { CLOSE_RANGE, LONG_RANGE }
enum WeaponItemVariationPrefix {BROKEN, RUSTY, DULL, SHARP, POLISHED }

@export var attack_type: AttackType
@export var item_variation:  WeaponItemVariationPrefix
@export var base_physical_damage: int
@export var base_magical_damage: int

@export var stamina_cost: int
@export var magic_cost: int

@export var is_multitarget: bool
@export var max_targets: int

@export var is_multihit: bool
@export var max_hits: int
