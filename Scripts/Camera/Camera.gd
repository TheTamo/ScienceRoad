extends Camera2D



@onready var player = $"../Player"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera_follow()
	
	
func camera_follow():
	anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
	position.x = player.position.x
	position.y = player.position.y - 60
	
