extends Bumper_Ship

var speed = 350
var bite_damage = 50
var aggro_range = 700
var is_aggro = false

signal aggro_on
signal aggro_off

func aggro_on():
	if not is_aggro:
		is_aggro = true
		emit_signal("aggro_on")

func aggro_off():
	if is_aggro:
		is_aggro = false
		emit_signal("aggro_off")

func _physics_process(delta):
	var distance = Connector.derp_star.global_position.distance_to(global_position)
	if distance < aggro_range:
		aggro_on()
		var target_angle = Connector.derp_star.global_position.angle_to_point(global_position)
		global_rotation = lerp_angle(global_rotation,target_angle,.05)
	else:
		aggro_off()
	linear_velocity = Vector2(speed,0).rotated(global_rotation)
	
func explode():
	var e = explosion.instantiate()
	e.transform = global_transform
	e.bumper_texture = $Polygon2D.texture
	e.width = 400
	e.height = 162
	emit_signal("spawn_explosion",e)


func _on_Bite_Area_body_entered(body):
	if body.faction != faction and not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("Chomp")

func deal_bite_damage():
	for body in $Bite_Area.get_overlapping_bodies():
		Connector.deal_damage(self,body,bite_damage)


func _on_AnimationPlayer_animation_finished(anim_name):
	for body in $Bite_Area.get_overlapping_bodies():
		if body.faction != faction and not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("Chomp")

