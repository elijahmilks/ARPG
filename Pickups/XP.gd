extends Area2D


@export var value: int = 1;

var velocity = Vector2(40.0, 0.0);
var rng = RandomNumberGenerator.new();
var initial_position: Vector2;
var pos_diff = Vector2(0.0, 0.0);


func _ready():
	if (!self.is_in_group("xp")):
		print(String(name) + " is not in group 'xp' but has XP script.");

	var angle = rng.randf_range(0, -PI);
	velocity = velocity.rotated(angle);
	initial_position = global_position;

func _physics_process(delta: float):
	if (pos_diff.y < 12):
		velocity += Vector2(0.0, 2.0);
		pos_diff = pos_diff + (velocity * delta);
		global_position = initial_position + pos_diff;

func collected(target: CharacterBody2D):
	# TODO animate this going to the player,
	# collision would need to be disabled, b/c the
	# player has already handled adding to total xp.
	# don't want it to trigger multiple times
	queue_free();
