extends Node2D


@onready var XP = preload("res://Pickups/XP.tscn");
@export var player: CharacterBody2D;
@export var screen_size: Vector2 = Vector2(960, 540);


func get_player():
	return player;

func get_screen_size():
	return screen_size;

func add_bullet(bullet: Node2D):
	$Bullets.add_child(bullet);


func _on_enemy_killed(enemy: Character):
	if (enemy.xp_value):
		var xp = XP.instantiate();
		xp.global_position = enemy.global_position;
		xp.value = enemy.xp_value;
		$XP.call_deferred("add_child", xp);

	enemy.queue_free();
