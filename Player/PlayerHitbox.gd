extends Area2D


# TODO if enemy stays in hitbox, more damage

func _on_body_entered(body: CharacterBody2D):
	if (body.is_in_group("enemy")):
		var damage = body.damage;
		get_parent().hit(damage);
