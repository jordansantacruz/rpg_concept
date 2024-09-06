extends Control

@onready var heart_UI_Full = $HeartUIFull
@onready var heart_UI_Empty = $HeartUIEmpty

var hearts = 4: set = set_hearts
var max_hearts = 4: set = set_max_hearts

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.health_changed.connect(set_hearts)
	PlayerStats.max_health_changed.connect(set_max_hearts)

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	heart_UI_Full.size.x = hearts * 15
	
func set_max_hearts(value):
	max_hearts = max(value, 1)
	heart_UI_Empty.size.x = max_hearts * 15
