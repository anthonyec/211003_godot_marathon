extends Camera

var target: Spatial
var offset: Vector3

func _ready() -> void:
	target = get_node('../Player')
	offset = global_transform.origin - target.global_transform.origin

func _process(delta: float) -> void:
	global_transform.origin = target.global_transform.origin + offset
	
