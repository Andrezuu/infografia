extends Marker2D

@export var speed: float = 100.0

# Este será el target que el Egg seguirá (si es necesario)
var target_position: Vector2 = Vector2.ZERO

func _ready():
	# Esto se ejecuta cuando el Egg se instancia en la escena
	print("Egg instanciado en la posición: ", global_position)

func _physics_process(delta: float) -> void:
	# Si hay un target, mover hacia el target
	if target_position != Vector2.ZERO:
		move_towards_target(delta)

func move_towards_target(delta: float) -> void:
	# Calcular la dirección hacia el target
	var direction = global_position.direction_to(target_position)
	# Mover el Egg hacia el target
	global_position += direction * speed * delta
