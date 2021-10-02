extends LineEdit

func _ready():
	connect("text_changed", self, "_on_text_changed")
	
var valid_chars = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F']
	
func _on_text_changed(_new_text):
	var t: String = text
	t = t.to_upper()
	
	var new_t = ""
	var chars_until_space = 2
	var had_invalid_chars = false
	for c in t:
		if chars_until_space <= 0:
			new_t += " "
			chars_until_space = 2
		if c in valid_chars:
			new_t += c
			chars_until_space -= 1
		else:
			if c != ' ': # Space is the only character that will be modified that's not invalid
				had_invalid_chars = true
			
		
			
	text = new_t
	caret_position = (text.length())
		
	
