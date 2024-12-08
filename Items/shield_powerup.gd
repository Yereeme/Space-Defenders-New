extends Powerup
#Thanks to CodeNMore
@export var shieldTime: float = 6

func applyPowerup(player: Player):
	player.applyShield
