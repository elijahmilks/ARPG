extends Area2D


func repel(time: float):
	var bodies = get_overlapping_bodies();
	for body in bodies:
		if (!body.is_in_group("enemy")): continue;

		body.repel(time);

func _on_area_entered(area: Area2D):
	if (area.is_in_group("xp")):
		get_parent().add_xp(area.value);
		area.collected(get_parent());
