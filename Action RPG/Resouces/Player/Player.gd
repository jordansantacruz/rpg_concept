extends CharacterBody2D

const PLAYER_HURT_SOUND = preload("res://Resouces/Music and Sounds/player_hurt_sound.tscn")

@export var ACCELERATION: int = 500
@export var MAX_SPEED: int = 80
@export var FRICTION: int = 500
@export var ROLL_SPEED: int = 125

@onready var animationPlayer = $AnimationPlayer
@onready var blinkAnimationPlayer = $BlinkAnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var swordHitBox = $HitboxPivot/SwordHitbox
@onready var hurtBox = $Hurtbox

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var roll_vector = Vector2.DOWN
var playerStats = PlayerStats

func _ready():
	playerStats.no_health.connect(queue_free)
	animationTree.active = true
	swordHitBox.knockback_vector = roll_vector
	velocity = Vector2.ZERO

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
	

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitBox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL

func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func roll_state(delta):
	velocity = roll_vector * MAX_SPEED * ROLL_SPEED * delta
	animationState.travel("Roll")
	move()
	
func move():
	move_and_slide()

func roll_animation_finished():
	velocity = velocity / 2
	state = MOVE

func attack_animation_finished():
	state = MOVE

func _on_hurtbox_area_entered(area):
	playerStats.health -= area.damage
	hurtBox.start_invincibility(0.8)
	hurtBox.create_hit_effect()
	var playerHurtSound = PLAYER_HURT_SOUND.instantiate()
	get_tree().current_scene.add_child(playerHurtSound)

func _on_hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_hurtbox_invincibiliy_ended():
	blinkAnimationPlayer.play("Stop")
