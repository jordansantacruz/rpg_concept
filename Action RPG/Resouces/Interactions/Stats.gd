extends Node

@export var max_health: int = 1: set = set_max_health
@onready var health = max_health: set = set_health 

signal max_health_changed(value)
signal health_changed(value)
signal no_health 

func _ready():
	self.health = max_health

func set_max_health(value):
	max_health = value
	if health != null:
		self.health = min(health, max_health)
	emit_signal("max_health_changed", value)

func set_health(value):
	health = value
	emit_signal("health_changed", value)
	if health <= 0:
		emit_signal("no_health")

