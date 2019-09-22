function init()
	? "[home_scene] init"
	m.top.backgroundURI = ""
	m.top.backgroundColor = "0xFFFFFFFF"
	m.center_square = m.top.findNode("center_square")
	m.center_square.setFocus(true)


	dom = parse_web("<html test='true'><body fontSize='16'><p>Hello, world!</p><p>More Text</p></body></html>")[0]
	m.parser = invalid
	css = parse_stylesheet("h1, h2, h3 { margin: auto; color: #cc0000; } div.note { margin-bottom: 20px; padding: 10px; } #answer { display: none; }")
	style_tree_result = style_tree(dom, css)
	m.parser = invalid

	layout_tree_value = build_layout_tree(style_tree_result.node)
	paint(layout_tree_value, {})
end function