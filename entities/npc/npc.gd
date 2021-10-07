extends Spatial

export var look_at_target: NodePath 

onready var clap_controller: Node = $ClapController;
onready var head: Spatial = $Head

var target: Spatial
var clap_radius: float = 5
var body_turn_speed: float = 4

var turn_to_face_target: bool = false

func _ready() -> void:
	# target = get_node(look_at_target)
	pass

func _process(delta: float) -> void:
	if target == null:
		return
	
	# Get the angle between the forward vector of the NPC and the vector pointing
	# towards the target (aka the player).
	# I worked this out on my own :')
	var direction_to_target = target.global_transform.origin - global_transform.origin
	var forward_angle_to_target = (-global_transform.basis.z).angle_to(direction_to_target)
	
	if abs(rad2deg(forward_angle_to_target)) > 45 && !turn_to_face_target:
		turn_to_face_target = true
		
	if abs(rad2deg(forward_angle_to_target)) < 5:
		turn_to_face_target = false
			
	if turn_to_face_target:
		var look_at_transform = transform.looking_at(target.global_transform.origin, Vector3.UP)
		transform = transform.interpolate_with(look_at_transform, body_turn_speed * delta)

	# Naughty way to ensure it only affects one axis.
	rotation_degrees.x = 0
	rotation_degrees.z = 0

	# Do head stuff.
	head.look_at(target.global_transform.origin, Vector3.UP)
	head.rotation_degrees.x = 0 
	head.rotation_degrees.z = 0
	
	var distance_to_target = translation.distance_to(target.global_transform.origin)

	if distance_to_target < clap_radius:
		clap_controller.start_clapping_with_delay()

func clap() -> void:
	clap_controller.clap()
