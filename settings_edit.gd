extends VBoxContainer

var mathpanel
var bubble
var num_random_points: int

func _ready() -> void:
	mathpanel = get_parent().get_node("MathPanel")
	bubble = get_parent().get_node("Bubble")
	$HBoxContainer/NumOfPoints.text = str(bubble.get_num_points())


func _on_add_random_points_pressed() -> void:
	mathpanel.activate(num_random_points)


func _on_num_random_points_value_changed(value: float) -> void:
	num_random_points = int(value)
	$AddRandomPoints.text = " " + str(num_random_points) + " RANDOM POINTS "


var wtween: Tween
func _on_bubble_num_points_changed(num_points: int) -> void:
	if (num_points >= 0):
		$HBoxContainer/NumOfPoints.text = str(num_points)
	else:
		if (wtween != null): wtween.kill()
		 
		wtween = get_tree().create_tween()
		$Warning.modulate = Color(1, 1, 1, 1)
		wtween.tween_property($Warning, "modulate", Color(1, 1, 1, 0), 2)
		wtween.play()
