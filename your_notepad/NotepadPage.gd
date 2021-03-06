extends Control

var page = 1
var last_page = 1

var pages = []

func _ready():
	$Page2.visible = false
	$Page3.visible = false
	$Page4.visible = false
	$Page5.visible = false
	$Page6.visible = false
	$Page7.visible = false
	
	setup_pages()
	

func build_pages():
	pages = [$PageTitle, $PageHelp1, $PageHelp2, $PageHelp3, $PageTB, $Page1]
	last_page = 6
	
	if GS.has_L:
		pages.append($Page2)
		last_page += 1
		
	if GS.has_R:
		pages.append($Page3)
		last_page += 1
		
	if GS.has_Turb:
		pages.append($Page4)
		last_page += 1
		
	if GS.has_SL:
		pages.append($Page5)
		last_page += 1
		
	if GS.has_SR:
		pages.append($Page6)
		last_page += 1
		
	if GS.has_DirB:
		pages.append($Page7)
		last_page += 1
		
	pages.append($PageEnd)
	last_page += 1

func turn(dir):
	var pnew = page + dir
	pnew = clamp(pnew, 1, last_page)

	if page != pnew:
		$Turn.play_sfx()

	page = pnew
	
func color_button(button, val):
	var c = Color.black
	if val:
		c = Color(0.4, 0.4, 0.4)
	button.modulate = c
	
func setup_pages():
	$Prev.visible = page > 1
	$Next.visible = page < last_page
	
	color_button($Prev, GS.hover_prev_button)
	color_button($Next, GS.hover_next_button)
	
	build_pages()
	
	var n = page - 1
	for p in pages:
		p.visible = (n == 0)
		n -= 1
		
func _process(delta):
	setup_pages()
