extends Area2D


@export var speed: float;
@export var damage: float;

const MAX_TIME_ALIVE = 6.0;

var direction: Vector2 = Vector2(0.0, 0.0);
var time_alive = 0.0;


func _physics_process(delta: float):
	time_alive += delta;
	if (time_alive > MAX_TIME_ALIVE): queue_free();

	if (direction == Vector2(0.0, 0.0)): return;

	var position_diff = direction * speed * delta;
	global_position += position_diff;


func _on_body_entered(body: CharacterBody2D):
	if (body.has_method("hit")):
		body.hit(damage);
		queue_free();
