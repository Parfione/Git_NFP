extends Node

const MIN_BG_VOL = -70.0
const MAX_BG_VOL = -24.0

func BG_vol_rate(rate:float):
	$Music.volume_db = lerp(MIN_BG_VOL,MAX_BG_VOL,rate)

func hover(play=true):
	if play:
		$Hover.play()
	else:
		$Hover.stop()

func click():
	$Click.play()

func vote():
	$Vote.play()

func typing(duration:float):
	await get_tree().create_timer(0.2).timeout
	$Typing.play()
	await get_tree().create_timer(duration-0.2).timeout
	$Typing.stop()
	
func sample():
	$Sample.play()
