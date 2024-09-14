extends Node2D

@onready var toggleObject = $ToggleObject

func _on_ToggleObject_interacted():
	print("GRAB CHEST")
