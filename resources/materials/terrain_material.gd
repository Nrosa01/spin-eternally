extends Resource
class_name TerrainMaterial

enum DAMAGE_TYPE {NONE, RECOIL, DEAD}

@export var name: StringName
@export var bouncable: bool = false
@export var bounce_multiplier: float = 0.6
@export var friction: float = 0.85
@export var sound: FMODAsset = null
@export var damage_type: DAMAGE_TYPE = DAMAGE_TYPE.NONE
