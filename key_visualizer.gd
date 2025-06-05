extends Area2D

func _physics_process(delta: float) -> void:
	self.position.y -= Settings.VISUALIZER_SPEED * delta
