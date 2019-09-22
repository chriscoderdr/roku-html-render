function init()
	? "[home_scene] init"
	m.top.backgroundURI = ""
	m.top.backgroundColor = "0xFFFFFFFF"
	m.center_square = m.top.findNode("center_square")
	m.center_square.setFocus(true)


	print parse_web("<html id='test'><body fontSize='16'>Hello, world!</body></html>")[0].node_type.element.attributes
	print parse_stylesheet("h1, h2, h3 { margin: auto; color: #cc0000; } div.note { margin-bottom: 20px; padding: 10px; } #answer { display: none; }")

end function