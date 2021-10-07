extends KinematicBody

var error = 1.1
var speed = 200

func _physics_process(delta: float) -> void:
	var direction: Vector3 = Vector3(0, 0, 0)

	var horizontalAxis = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var verticalAxis = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	var input = Vector2(
		clamp(horizontalAxis * error, -1, 1),
		clamp(verticalAxis * error, -1, 1)
	);

	var inputCircle = Vector2(
		input.x * sqrt(1 - input.y * input.y * 0.5),
		input.y * sqrt(1 - input.x * input.x * 0.5)
	)

	direction += Vector3(inputCircle.x, 0, inputCircle.y) * speed

	var look_at_transform = transform.looking_at(self.global_transform.origin + direction, Vector3.UP)
	transform = transform.interpolate_with(look_at_transform, 10 * delta)

	move_and_slide(direction * delta)
