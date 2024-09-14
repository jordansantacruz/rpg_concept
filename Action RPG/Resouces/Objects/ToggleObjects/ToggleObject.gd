extends Area2D

@export var loopable = false
@export var toggled = false;

@onready var onSprite = $OnSprite
@onready var offSprite = $OffSprite
@onready var collisionShape = $CollisionShape2D

signal interacted

func interact():
	if !toggled:
		toggled = true
		onSprite.visible = false;
		offSprite.visible = true;
		emit_signal("interacted")
	elif loopable:
		toggled = false
		onSprite.visible = true;
		offSprite.visible = false;
		emit_signal("interacted")
	
	if !loopable && toggled:
		collisionShape.disabled = true
		
