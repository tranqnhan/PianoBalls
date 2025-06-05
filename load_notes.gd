extends Node

signal key_pressed(key_name)

const A = preload("res://note_sounds/A.wav")
const Ab = preload("res://note_sounds/Ab.wav")
const B = preload("res://note_sounds/B.wav")
const Bb = preload("res://note_sounds/Bb.wav")
const C = preload("res://note_sounds/C.wav")
const D = preload("res://note_sounds/D.wav")
const Db = preload("res://note_sounds/Db.wav")
const E = preload("res://note_sounds/E.wav")
const Eb = preload("res://note_sounds/Eb.wav")
const F = preload("res://note_sounds/F.wav")
const Fs = preload("res://note_sounds/Fs.wav")
const G = preload("res://note_sounds/G.wav")

const NOTES = [A, Ab, B, Bb, C, D, Db, E, Eb, F, Fs, G]
const NAMES = ["A", "Ab", "B", "Bb", "C", "D", "Db", "E", "Eb", "F", "Fs", "G"]

func get_note_id_from_pos(pos: float, max_pos: float):
	var n = int((pos / max_pos) * len(NOTES))
	n = min(n, len(NOTES) - 1)
	n = max(n, 0)
	return n


func get_note(id):
	key_pressed.emit(NAMES[id])
	return NOTES[id]
