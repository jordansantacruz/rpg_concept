extends Area2D

@onready var sprite = $Sprite

signal interacted

func interact():
	print("sending interact signal...")
	emit_signal("interacted")
