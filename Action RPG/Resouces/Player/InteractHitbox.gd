extends Area2D

@onready var collisionShape2D = $CollisionShape2D

func _ready():
	collisionShape2D.disabled = true
	
func interact():
	collisionShape2D.disabled = false
	
