extends Weapon


var Bullet = preload("res://Gear/Weapons/Bullet.tscn");
var damage = 10.0;


func create_bullet(direction: Vector2):
	var bullet = Bullet.instantiate();
	bullet.direction = direction;
	bullet.damage = damage;
	return bullet;
