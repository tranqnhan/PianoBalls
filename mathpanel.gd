extends Panel


var solution: int
var num_of_points: int
var bubble


func _ready() -> void:
	self.visible = false
	bubble = get_parent().get_node("Bubble")


func activate(num_random_points: int):
	var n1 = randi_range(1, 10)
	var n2 = randi_range(1, 10)
	solution = n1 + n2
	
	self.num_of_points = num_random_points
	$VBoxContainer/Equation.text = str(n1) + " + " + str(n2) + " ="
	self.visible = true


func _on_numpad_numpad_enter_pressed(number: int) -> void:
	if (solution == number):
		bubble.add_random_points(self.num_of_points)
		self.visible = false
