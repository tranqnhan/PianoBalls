extends ColorRect


var tween: Tween 


func params(is_black, key_name):
	self.color = Color(0, 0, 0, 1) if is_black else Color(1, 1, 1, 1)
	$CenterContainer/Label.modulate = Color(1, 1, 1, 1) if is_black else Color(0, 0, 0, 1)
	$CenterContainer/Label.text = key_name


func key_pressed():
	if (!Settings.HIGHLIGHT_KEY): return
	
	if (tween != null): tween.kill()
	 
	tween = get_tree().create_tween()
	$CenterContainer/Highlight.modulate = Color(1, 1, 1, 1)
	tween.tween_property($CenterContainer/Highlight, "modulate", Color(1, 1, 1, 0), 0.5)
	tween.play()
