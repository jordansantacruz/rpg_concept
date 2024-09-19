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
	var empty_playspace = get_node_or_null("/root/PlaySpace")
	if empty_playspace != null:
		empty_playspace.queue_free()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func transition_playspace(target_playspace_path, spawn_point_id):
	var target_playspace = load(target_playspace_path)
	reparent_persistant_objects(self)
	playspace_root.queue_free()
	await get_tree().process_frame
	var Target_Playspace = target_playspace.instantiate()
	add_child(Target_Playspace)
	playspace_root = get_node("/root/GameManager/PlaySpace")
	var camera_limits = get_node("/root/GameManager/PlaySpace/Limits")
	reparent_persistant_objects(playspace_root)
	camera.update_limits(camera_limits.get_child(0), camera_limits.get_child(1))
	var spawn = determine_spawn(spawn_point_id)
	player.global_position = spawn.global_position
	
func determine_spawn(spawn_point_id):
	var transition_areas = get_node("PlaySpace/TransitionAreas").get_children()
	var transition_area_name = "TransitionArea"
	if spawn_point_id != 0:
		transition_area_name = transition_area_name + str(spawn_point_id)
	for area in transition_areas:
		if area.name == transition_area_name:
			return area.get_node("SpawnPoint")
	
	return transition_areas[0].get_node("SpawnPoint")

func set_up_scene_and_player(target_scene):
	var Scene_Inst = target_scene.instantiate()
	add_child(Scene_Inst)
	playspace_root = get_node("/root/GameManager/PlaySpace")
	var player_spawn = get_node("/root/GameManager/PlaySpace/PlayerSpawn")
	var camera_limits = get_node("/root/GameManager/PlaySpace/Limits")
	call_deferred("reparent_persistant_objects", playspace_root)
	camera.update_limits(camera_limits.get_child(0), camera_limits.get_child(1))
	player.global_position = player_spawn.global_position

func reparent_persistant_objects(new_parent):
	player.reparent(new_parent)
	camera.reparent(new_parent)
	canvas.reparent(new_parent)	
	player.get_node("RemoteTransform2D").remote_path = camera.get_path()

func add_child_to_playspace(instance):
		call_deferred("add_child_to_playspace_deferred", instance)

func add_child_to_playspace_deferred(instance):
	playspace_root.add_child(instance)
