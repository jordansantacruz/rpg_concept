extends CharacterBody2D

@export var ACCELERATION = 1000
@export var MAX_SPEED = 50
@export var FRICTION = 200
@export var WANDER_TARGET_BREAK = 4

@onready var animatedSprite = $AnimatedSprite
@onready var playerDetection = $PlayerDetection

enum {
	SPAWN,
	IDLE,
	CHASE
}

var state = IDLE
var spawn_vector
var spawn_speed

func _ready():
	velocity = Vector2.ZERO
	animatedSprite.play("animate")

func _physics_process(delta):
	match state:
		SPAWN:
			velocity = velocity.move_toward(spawn_vector * MAX_SPEED, spawn_speed * delta)
			state = IDLE
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		CHASE:
			var player = playerDetection.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
	
	move_and_slide()

func spawn(scatter_vector, scatter_speed):
	spawn_vector = scatter_vector
	spawn_speed = scatter_speed
	state = SPAWN

func accelerate_towards_point(position, delta):
	var direction = global_position.direction_to(position).normalized()
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

func seek_player():
	if(playerDetection.can_see_player()):
		state = CHASE

func _on_PickUpArea_body_entered(body):
	queue_free()
