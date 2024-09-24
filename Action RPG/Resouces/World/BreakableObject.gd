extends Node

@export var HEALTH: int

@onready var sprite2D = $Sprite2D

var spawner
var brokenSprite2D

func _ready():
	spawner = get_node_or_null("Spawner")
	brokenSprite2D = get_node_or_null("BrokenSprite2D")

func _on_area_2d_area_entered(area):
	HEALTH = HEALTH - 1
	if HEALTH > 0:
		spawner.spawn_objects()	
	else:
		sprite2D.visible = false
		if brokenSprite2D != null:
			brokenSprite2D.visible = true
