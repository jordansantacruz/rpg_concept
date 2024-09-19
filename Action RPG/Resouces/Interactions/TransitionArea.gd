extends Area2D

var transitioning = false;

@export var TRANSITION_PLAYSPACE_PATH:String
@export var SPAWN_POINT_ID: int

@onready var spawnPoint = $SpawnPoint
@onready var gameManager = GameManager

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func transition_deffered():
	gameManager.transition_playspace(TRANSITION_PLAYSPACE_PATH, SPAWN_POINT_ID)

func _on_body_entered(body):
	if !transitioning:
		transitioning = true
		call_deferred("transition_deffered") 
