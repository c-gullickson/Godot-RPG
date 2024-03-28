extends Button

signal custom_character_start()

func on_pressed():
	emit_signal("custom_character_start")
