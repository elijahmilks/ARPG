extends Node2D

signal on_enemy_killed(enemy: Character);
signal on_enemy_count_changed(count: int);


@export var spawn_rate: float;
@export var spawn_rate_min: float;
@export var spawn_rate_decrease: float;
@export var spawn_rate_decrease_rate: float;

const SCREEN_BUFFER = 20;
const ENEMY_COUNT_CAP = 400;
const SPAWN_RANGE = 560.0;

# range has some padding so enemies don't spawn and immediately despawn
var SQR_SPAWN_RANGE = Vector2(0.0, 0.0).distance_squared_to(Vector2(SPAWN_RANGE + 40.0, 0));
# min_range (11.0) comes from radius of player collision capsule
var SQR_MIN_RANGE = Vector2(0.0, 0.0).distance_squared_to(Vector2(11.0, 0.0));

var BallEnemy = preload("res://Enemies/BallEnemy.tscn");
var spawn_time = 0.0;
var rate_decrease_time = 0.0;
var rng = RandomNumberGenerator.new();
var player: CharacterBody2D;
var enemy_count: int = 0;
var enemy_queue: int = 0;


func _ready():
	player = get_parent().get_player();

# THE LAG HAS TO BE COMING FROM COLLISIONS
# add a cap to how many enemies can spawn at once
# once that cap is reached, start adding to a queue int (# of enemies waiting to spawn)
# when an enemy dies, spawn another and - 1 to the queue
# when an enemy gets too far from the player, despawn it and spawn another 180 deg. on the opposite side of the player

func _physics_process(delta: float):
	move_enemies(delta);

func _process(delta: float):
	spawn_time += delta;
	rate_decrease_time += delta;

	if (spawn_time >= spawn_rate):
		spawn_time = 0.0;
		spawn();

	if (rate_decrease_time >= spawn_rate_decrease_rate):
		spawn_rate -= spawn_rate_decrease;
		if (spawn_rate < spawn_rate_min): spawn_rate = spawn_rate_min;
		rate_decrease_time = 0.0;

func move_enemies(delta: float):
	for enemy in get_children():
		var diff = player.global_position - enemy.global_position;
		var sqr_distance = enemy.global_position.distance_squared_to(player.global_position);
		if (sqr_distance > SQR_SPAWN_RANGE):
			# despawn and spawn on the opposite side of the character
			var new_pos = player.global_position + (diff.normalized() * SPAWN_RANGE);
			enemy.global_position = new_pos;

		if (sqr_distance <= SQR_MIN_RANGE):
			enemy.velocity = Vector2(0.0, 0.0);
		else:
			enemy.velocity = diff.normalized() * enemy.move_speed;

func spawn():
	if (enemy_count >= ENEMY_COUNT_CAP):
		enemy_queue += 1;
		return;

	var angle = rng.randf_range(0, 2 * PI);
	var spawn_pos = player.global_position + Vector2(SPAWN_RANGE, 0.0).rotated(angle);

	var enemy = BallEnemy.instantiate();
	enemy.global_position = spawn_pos;
	enemy.target = player;
	enemy.on_killed.connect(_on_enemy_killed);
	add_child(enemy);
	change_enemy_count(1);

	if (enemy_queue > 0):
		enemy_queue -= 1;

func change_enemy_count(diff: int):
	enemy_count += diff;
	emit_signal("on_enemy_count_changed", enemy_count);

func _on_enemy_killed(enemy: Character):
	remove_child(enemy);
	change_enemy_count(-1);
	emit_signal("on_enemy_killed", enemy);

	if (enemy_queue > 0):
		spawn();
