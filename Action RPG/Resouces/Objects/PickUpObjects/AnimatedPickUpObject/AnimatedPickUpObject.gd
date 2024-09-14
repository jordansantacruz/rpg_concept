extends KinematicBody2D

export var ACCELERATION = 1000
export var MAX_SPEED = 50
export var FRICTION = 200
export var WANDER_TARGET_BREAK = 4

onready var animatedSprite = $AnimatedSprite
onready var playerDetection = $PlayerDetection

enum {
	IDLE,
	CHASE
}

var velocity = Vector2.ZERO
var state = IDLE

func _ready():
	animatedSprite.play("animate")

func _physics_process(delta):
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		CHASE:
			var player = playerDetection.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
	
	velocity = move_and_slide(velocity)
	
func accelerate_towards_point(position, delta):
	var direction = global_position.direction_to(position).normalized()
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

func seek_player():
	if(playerDetection.can_see_player()):
		state = CHASE

func _on_PickUpArea_body_entered(body):
	Inventory.offsetCoins(1)
	queue_free()
