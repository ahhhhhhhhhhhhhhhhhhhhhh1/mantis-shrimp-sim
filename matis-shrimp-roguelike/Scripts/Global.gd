extends Node
var sand_dollar = 0
var player_health = 100
var _flash = 0
var player_pos = Vector3(0, 0, 0)
var player_obj

func flash(): # this is done so u can just call global.flash()
	_flash = 1# instead of global.flash = 1

class player: # values to base enemy stats on. (ask riley)
	const health = 125
	const speed = 1.0
	const dash_speed = 1.0
	const damage = 10
	class power_punch:
		const dmg = 30
		const charge_time = 5
	const shield = 50
	const regen = 0.1 # 1/sec

var difficulty = 1
