extends Node2D


@export var bubble: PackedScene
@export var popped_effect: PackedScene


func _ready() -> void:
	var n1 = randi_range(1, 10)
	var n2 = randi_range(1, 10)
	add_bubble(Vector2(randf() * 1000 + 100, 750), randf() * 10 + 50, str(n1) + "+" + str(n2), n1 + n2)


func add_bubble(position, radius, equation, value):
	var b = bubble.instantiate()
	b.params(position, radius, equation, value)
	$Bubbles.add_child(b)
	

func _on_numpad_numpad_enter_pressed(number: int) -> void:
	for i in $Bubbles.get_children():
		if (i.get_value() == number):
			var p: CPUParticles2D = popped_effect.instantiate()
			p.position = i.position
			p.emitting = true
			p.finished.connect(func(): p.queue_free())
			self.add_child(p)
			i.queue_free()
			
			var n1 = randi_range(1, 10)
			var n2 = randi_range(1, 10)
			add_bubble(Vector2(randf() * 1000 + 100, 800), randf() * 10 + 50, str(n1) + "+" + str(n2), n1 + n2)
