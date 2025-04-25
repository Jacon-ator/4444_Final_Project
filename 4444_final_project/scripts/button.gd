extends Button

func _button_pressed():
	var PF_Button
	load(PF_Button.new)
	PF_Button.text = "PathFinder Toggle"
	
