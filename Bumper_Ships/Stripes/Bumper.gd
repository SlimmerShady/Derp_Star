extends Bumper_Ship

func on_ready():
	$Thruster.activate()

func _on_Timer_timeout():
	$Thruster.toggle()
	$Thruster2.toggle()
