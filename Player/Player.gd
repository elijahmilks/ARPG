extends Character


@export var weapon: Weapon;

const DIR = {
	"N": "n",
	"S": "s",
	"E": "e",
	"W": "w",
	"NE": "ne",
	"NW": "nw",
	"SE": "se",
	"SW": "sw",
};

var current_direction = DIR.S;
var xp: int = 0;
var invincibility = 0;
var i_time = 0.5;


func _ready():
	$Camera2D/UI/HealthBar.max_value = self.health;
	$Camera2D/UI/HealthBar.value = self.health;

func add_xp(amount: int):
	xp += amount;
	$Camera2D/UI/XPLabel.text = str(xp);

func hit(damage: float):
	if (!invincibility):
		super.hit(damage);
		invincibility = i_time;
		$PickupRadius.repel(i_time);

func damaged(new_health: int):
	$Camera2D/UI/HealthBar.value = self.health;

func process(delta: float):
	if (invincibility > 0.0):
		invincibility -= delta;
		if (invincibility < 0.0): invincibility = 0.0;

	_input_process(delta);

func move(delta: float):
	_update_velocity(delta);
	_update_rotation(delta);

	var animation_name = current_direction;
	if (velocity.x == 0 && velocity.y == 0): animation_name += "_idle";
	else: animation_name += "_move";

	$AnimatedSprite2D.play(animation_name);
	move_and_slide();

func _input_process(delta: float):
	if (Input.is_action_pressed("fire")):
		var direction = (get_global_mouse_position() - global_position).normalized();
		weapon.fire(direction, get_parent());

func _update_velocity(delta: float):
	velocity = Vector2(0, 0);

	if (Input.is_action_pressed("left")):
		velocity.x -= 1;
	if (Input.is_action_pressed("right")):
		velocity.x += 1;
	if (Input.is_action_pressed("up")):
		velocity.y -= 1;
	if (Input.is_action_pressed("down")):
		velocity.y += 1;
	velocity = velocity.normalized();

	velocity *= move_speed;

func _update_rotation(delta: float):
	if (velocity.x < 0):
		if (velocity.y < 0):
			current_direction = DIR.NW;
		elif (velocity.y > 0):
			current_direction = DIR.SW;
		else:
			current_direction = DIR.W;
	elif (velocity.x > 0):
		if (velocity.y < 0):
			current_direction = DIR.NE;
		elif (velocity.y > 0):
			current_direction = DIR.SE;
		else:
			current_direction = DIR.E;
	elif (velocity.y < 0):
		current_direction = DIR.N;
	elif (velocity.y > 0):
		current_direction = DIR.S;

func _on_enemy_count_changed(count: int):
	$Camera2D/UI/DebugLabel.text = str(count);
