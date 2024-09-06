extends Node2D

@onready var forest_scene = preload("res://PlaySpaces/ForestNoPlayer.tscn")
@onready var village_scene = preload("res://PlaySpaces/Village.tscn")

#Persistent objects
@export var player: CharacterBody2D
@export var camera: Camera2D
@export var canvas: CanvasLayer
var playspace_root


var current_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	set_up_scene_and_player(forest_scene)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("debug"):
		debug_change_scene(village_scene)

func debug_change_scene(target_scene):
	reparent_persistant_objects(self)
	playspace_root.queue_free()
	await get_tree().process_frame
	var Target_Scene = target_scene.instantiate()
	add_child(Target_Scene)
	playspace_root = get_node("/root/GameManager/PlaySpace")
	var player_spawn = get_node("/root/GameManager/PlaySpace/PlayerSpawn")
	var camera_limits = get_node("/root/GameManager/PlaySpace/Limits")
	reparent_persistant_objects(playspace_root)
	camera.update_limits(camera_limits.get_child(0), camera_limits.get_child(1))
	player.global_position = player_spawn.global_position

func set_up_scene_and_player(target_scene):
	var Scene_Inst = target_scene.instantiate()
	add_child(Scene_Inst)
	playspace_root = get_node("/root/GameManager/PlaySpace")
	var player_spawn = get_node("/root/GameManager/PlaySpace/PlayerSpawn")
	var camera_limits = get_node("/root/GameManager/PlaySpace/Limits")
	reparent_persistant_objects(playspace_root)
	camera.update_limits(camera_limits.get_child(0), camera_limits.get_child(1))
	player.global_position = player_spawn.global_position


func reparent_persistant_objects(new_parent):
	player.reparent(new_parent)
	camera.reparent(new_parent)
	canvas.reparent(new_parent)	
	player.get_node("RemoteTransform2D").remote_path = camera.get_path()
	var i = 1
	
