extends RigidBody2D

func _on_Area2D_body_entered(body):
	body.add_energy(50)
	queue_free()

func _on_Timer_timeout():
	queue_free()
