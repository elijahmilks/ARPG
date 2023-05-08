extends Node
class_name EquippedGear

@export var head: HandsEquipment = null;
@export var torso: TorsoEquipment;
@export var legs: LegsEquipment;
@export var feet: FeetEquipment;
@export var hands: HandsEquipment;
@export var right_hand_weapon: Weapon;
@export var left_hand_weapon: Weapon;
#@export var back: BackEquipment;

func _ready():
	pass;
