extends Node2D

@export var wander_range = 32
@onready var start_Position = global_position
@onready var target_Position = global_position
@onready var timer = $Timer

func _read():
	update_target_position()

func update_target_position():
	var target_vector = Vector2(randi_range(wander_range * -1,wander_range), 
	randi_range(wander_range * -1, wander_range))
	target_Position = start_Position + target_vector

func start_wander_timer(duration):
	timer.start(duration)

func get_time_left():
	return timer.time_left

func _on_timer_timeout():
	update_target_position()
