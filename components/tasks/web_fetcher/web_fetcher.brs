sub init()
    m.top.functionName = "fetchSubs"
end sub

sub fetchSubs()
    content = CreateObject("RoSGNode", "ContentNode")
    request = CreateObject("roUrlTransfer")
    port = CreateObject("roMessagePort")
    request.SetMessagePort(port)
    request.SetCertificatesFile("common:/certs/ca-bundle.crt") ' or another appropriate certificate
    request.InitClientCertificates()
    request.SetUrl("https://limpet.net/mbrubeck/2014/08/08/toy-layout-engine-1.html")
    dom_text = request.GetToString()
    ' print response
    ' dom = parse_web("<html><body>Test</body></html>")
    ' dom_text = ReadAsciiFile("pkg:/test.html")
    regex_image = createObject("roRegex", "</img*>", "m")
    regex_span = createObject("roRegex", "</?span[^>]*>", "i")
    regex_empty = createObject("roRegex", "<[^\/>][^>]*><\/[^>]+>", "i")
    regex_links = createObject("roRegex", "</?a[^>]*>", "i")
    regex_span = createObject("roRegex", "</?span[^>]*>", "i")
    regex_tags = createObject("roRegex", "<([^\/>]+)\/>", "i")
    regex = CreateObject("roRegex", "<!--[\s\S]*?-->", "m")
    dom_text = regex_span.replaceAll(regex_tags.replaceAll(regex.ReplaceAll(Mid(dom_text, InStr(0, dom_text, "<body>")).replace("</html>", ""), ""), ""), "")
    dom_text = regex_links.replaceAll(dom_text, "")
    dom_text = regex_empty.replaceAll(dom_text, "")
    dim_text = regex_image.replaceAll(dom_text, "")
    dom = parse_web(dom_text)
    m.parser = invalid
    css = parse_stylesheet("h1, h2, h3 { margin: auto; color: #cc0000; } div.note { margin-bottom: 20px; padding: 10px; } #answer { display: none; }")
    style_tree_result = style_tree(dom, css)
    m.parser = invalid

    layout_tree_value = build_layout_tree(style_tree_result.node)
    print layout_tree_value
    m.top.content = layout_tree_value

end sub