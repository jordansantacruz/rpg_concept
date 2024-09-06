extends Area2D

const HitEffect = preload("res://Resouces/Effects/HitEffect.tscn")

@onready var timer = $Timer

var invincible = false : set = _set_invincible 

signal invincibility_started
signal invincibiliy_ended

func _set_invincible(new_state):
	invincible = new_state
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibiliy_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var effect = HitEffect.instantiate()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func _on_timer_timeout():
	self.invincible = false

func _on_invincibility_started():
	set_deferred("monitoring", false)

func _on_invincibiliy_ended():
	monitoring = true
