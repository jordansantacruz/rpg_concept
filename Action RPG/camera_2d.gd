extends Camera2D

@onready var top_left = $Limits/TopLeft
@onready var bottom_right = $Limits/BottomRight

func _ready():
	limit_left = top_left.position.x
	limit_top = top_left.position.y
	
	limit_right = bottom_right.position.x
	limit_bottom = bottom_right.position.y

func update_limits(new_top_left, new_bottom_right):	
	limit_left = new_top_left.position.x
	limit_top = new_top_left.position.y
	
	limit_right = new_bottom_right.position.x
	limit_bottom = new_bottom_right.position.y

