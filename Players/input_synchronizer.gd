extends MultiplayerSynchronizer

@export var attacking := false

# Synchronized property.
@export var direction := Vector2()

func _ready():
	# Only process for the local player
	var is_local: bool = get_multiplayer_authority() == multiplayer.get_unique_id()
	set_process(is_local)
	
@rpc("call_local")
func attack():
	attacking = true

func _process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("Left", "Right", "Up", "Down")
	if Input.is_action_pressed("Attack"):
		attack.rpc()

func _on_animated_sprite_2d_animation_finished() -> void:
	attacking = false
