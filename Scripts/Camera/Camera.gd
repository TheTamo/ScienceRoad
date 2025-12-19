extends Camera2D

@onready var player = $"../Player"

@export var follow_speed_x := 6.0
@export var follow_speed_y := 3.0
@export var y_offset := 150.0

func _ready() -> void:
	anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER

func _process(delta):
	camera_follow(delta)

func camera_follow(delta):
	var target_x = player.global_position.x
	var target_y = player.global_position.y - y_offset

	global_position.x = lerp(global_position.x, target_x, follow_speed_x * delta)
	global_position.y = lerp(global_position.y, target_y, follow_speed_y * delta)
