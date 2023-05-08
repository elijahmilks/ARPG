extends Node2D
class_name Weapon


@export var reload_rate: float;

var reload = 0.0;


func _physics_process(delta: float):
	if (reload > 0.0):
		reload -= delta;
		if (reload < 0.0): reload = 0.0;

func fire(direction: Vector2, spawn_target: Node2D):
	if (reload <= 0.0):
		reload = reload_rate;

		var bullet = self.create_bullet(direction);
		bullet.global_position = global_position;
		spawn_target.add_bullet(bullet);


func create_bullet(direction: Vector2):
	push_error("create_bullet is an abstract method that has not been created on Weapon: " + String(name));
