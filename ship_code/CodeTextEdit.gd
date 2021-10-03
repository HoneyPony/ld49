extends LineEdit

func _ready():
	connect("text_changed", self, "_on_text_changed")
	
	var level = GS.find_level(GS.current_level_id)
	if level != null:
		text = level.last_code
	
var valid_chars = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F']
	
var the_code = ""
	
func update_level_code():
	if GS.current_level_info != null:
		GS.current_level_info.last_code = text
	
func _on_text_changed(_new_text):
	
	
	var t: String = text.substr(0, 3 * 7 + 2)
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
	
	the_code = text
	
	update_level_code()
	
func highlight_code(which):
	if which == -25:
		highlight_none()
		return
		
	if which == -50:
		highlight_none()
		return
	
	last_highlighted_code = which
	var code_begin = which * 3
	var code_end = code_begin + 2
	
	select(code_begin, code_end)
	
func highlight_none():
	if last_highlighted_code == -50:
		return
	
	last_highlighted_code = -25
	deselect()
	
	text = "CO DE  W RO NG"
	
func highlight_won():
	last_highlighted_code = -50
	deselect()
	
	text = "CO DE  C OR RE CT"
	
var last_highlighted_code = 0
var is_highlighting_code = false
	
func _process(delta):
	if is_highlighting_code:
		highlight_code(last_highlighted_code)
		
	
		
func ready_playing():
	selecting_enabled = true
	is_highlighting_code = true
	focus_mode = FOCUS_NONE
	
func ready_done():
	selecting_enabled = true
	is_highlighting_code = false
	focus_mode = FOCUS_ALL
	deselect()
	caret_position = (text.length())
	
	text = the_code
	
