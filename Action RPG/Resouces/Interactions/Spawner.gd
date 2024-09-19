extends Node2D

@export var SPAWN_OBJECT_PATH:String
@export var SPAWN_OBJECT_MIN:int
@export var SPAWN_OBJECT_MAX:int
@export var SCATTER_VELOCITY:int

@onready var gameManager = GameManager

var spawn_packed_scene

func _ready():
	spawn_packed_scene = load(SPAWN_OBJECT_PATH)
	if spawn_packed_scene == null:
		queue_free()
		
func spawn_objects():
	var spawn_amt = randi_range(SPAWN_OBJECT_MIN, SPAWN_OBJECT_MAX)
	for n in range(0, spawn_amt):
		#spawn object
		var instance = spawn_packed_scene.instantiate()
		instance.global_position = global_position
		#reparent object
		gameManager.add_child_to_playspace(instance)
		#apply random direction velocity
		var rand_vector = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		instance.spawn(rand_vector, SCATTER_VELOCITY)

