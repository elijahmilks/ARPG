extends Character

signal on_killed(enemy: Character);


enum EFFECTS {
	STUNNED,
	REPELLED,
};

@export var xp_value: int;
@export var damage: int;

var stunned = false;
var world;
var target: Character;
var repel_time = 0.0;
var effects = {};
# effects:
#	keys: what effects the enemy currently has
#	values: (int) how long the effect lasts (-1 is indefinte)
#	"stunned": move speed = 0
#	"repelled": move away from player

# toy around with slower rate of enemies once a timer is added
# instead have triggers around the map for hordes?	


func _ready():
	if (!self.is_in_group("enemy")):
		print(String(name) + " is not in group 'enemy' but has Enemy script.");

	world = get_tree().root.get_child(0);
	target = world.get_player();

func repel(time: float):
	repel_time = time;

func set_stunned(new_stunned: bool):
	stunned = new_stunned;
	if (stunned): velocity = Vector2(0.0, 0.0);

func handle_repel(delta: float):
	if (repel_time > 0.0):
		repel_time -= delta;
		if (repel_time < 0.0): repel_time = 0.0;
		velocity *= -1;

func move(delta: float):
	if (effects.has(EFFECTS.STUNNED)):
		return;
	elif (effects.has(EFFECTS.REPELLED)):
		velocity = -velocity;

	move_and_slide();

func die():
	emit_signal("on_killed", self);
