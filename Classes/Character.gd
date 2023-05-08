extends CharacterBody2D
class_name Character


@export var move_speed: int;
@export var health: int;
@export var equipment: EquippedGear;

func _physics_process(delta: float):
	if (self.has_method("process")):
		process(delta);

	if (self.has_method("move")):
		move(delta);
	else:
		move_and_slide();

func hit(damage: float):
	self.health -= damage;
	damaged(self.health);

	if (self.health <= 0.0):
		die();

func die():
	queue_free();

func move(delta: float):
	move_and_slide();

func process(delta: float):
	pass;

func damaged(health: int):
	pass;
