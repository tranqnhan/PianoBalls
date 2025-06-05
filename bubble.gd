extends Node2D


var radius: float
var vy = 0
var vx = 0

const vyScale = 2
const vxScale = 2

var value: int

func _ready() -> void:
	$Equation.position -= $Equation.size / 2


func params(position: Vector2, radius: float, equation: String, value: int):
	self.position = position
	self.radius = radius
	self.vy = -randf() * vyScale
	self.vx = (randf() - 0.5) * self.vxScale
	$Equation.text = equation
	self.value = value


func get_value():
	return self.value


func _physics_process(delta: float) -> void:
	self.position.y = self.position.y + self.vy


func _draw() -> void:
	draw_circle(Vector2.ZERO, self.radius, Color(1, 0.0, 0.0, 1), false, -1.0, false)
