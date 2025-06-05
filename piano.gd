extends Control

@export var key: PackedScene
@export var key_visualizer: PackedScene

var keys = {}

func _ready() -> void:
	for i in LoadNotes.NAMES:
		var is_black = len(i) > 1
		var k = key.instantiate()
		k.params(is_black, i)
		$Keyboard.add_child(k)
		keys[i] = k
		
	LoadNotes.key_pressed.connect(self.key_pressed)


func key_pressed(key_name):
	keys[key_name].key_pressed()
	$Notes/M/Notes.text += key_name + " "
	if (len($Notes/M/Notes.text) > 150):
		var i = $Notes/M/Notes.text.find(" ")
		$Notes/M/Notes.text = $Notes/M/Notes.text.substr(i+1, -1)
	
	if (Settings.VISUALIZER):
		var k = key_visualizer.instantiate()
		k.position = keys[key_name].position
		$Visualizer.add_child(k)


func _on_key_visualizer_despawn_area_entered(area: Area2D) -> void:
	area.queue_free()
	
