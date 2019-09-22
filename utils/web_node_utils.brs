function create_web_text_node(data as string) as object:
    node = createObject("RoSGNode", "WebNode")
    node.children = CreateObject("roArray", 26, true)
    node.node_type = createObject("RoSGNode", "WebNodeType")
    node.node_type.text = data
    return node
end function

function create_web_node_element(name as string, attrs, children) as object:
    node = createObject("RoSGNode", "WebNode")
    node.children = children
    node.node_type = createObject("RoSGNode", "WebNodeType")
    node.node_type.element = createObject("RoSGNode", "ElementData")
    node.node_type.element.tag_name = name
    node.node_type.element.attributes = attrs
    return node
end function


function create_parser(position as integer, input as string) as object:
    parser = createObject("RoSGNode", "WebParser")
    parser.pos = position
    parser.input = input
    return parser
end function


function next_char() as string:
    next_char_value = Mid(m.parser.input, m.parser.pos, 1)
    return next_char_value
end function

function starts_with(s as string) as boolean:
    return Mid(m.parser.input, m.parser.pos, Len(s)) = s
end function

function eof() as boolean:
    return m.parser.pos >= Len(m.parser.input)
end function

function consume_char() as string:
    current_char = Mid(m.parser.input, m.parser.pos, 1)
    m.parser.pos = m.parser.pos + 1
    return current_char
end function

function consume_while(test as function) as string:
    result = ""
    while true:
        if (not test(next_char())):
            exit while
        else if (eof()):
            exit while
        end if
        result += consume_char()
    end while
    return result
end function

function char_is_white_space(char as string) as boolean:
    return (char = " ")
end function


sub consume_whitespace():
    consume_while(char_is_white_space)
end sub

function char_is_not_tag(char as string) as boolean:
    regex = CreateObject("roRegex", "[a-zA-Z0-9]", "i")
    return regex.isMatch(char)
end function

function parse_tag_name() as string:
    return consume_while(char_is_not_tag)
end function


function char_is_open(char as string) as boolean:
    return char <> "<"
end function

function parse_text() as object:

    text_value = consume_while(char_is_open)
    return text_value
end function

function parse_element() as object:
    consume_char()
    tag_name = parse_tag_name()
    attributes = parse_attributes()

    children = parse_nodes(m.parser)

    consume_char()
    consume_char()
    parse_tag_name()
    consume_char()
    return create_web_node_element(tag_name, attributes, children)
end function

function parse_attr() as object:
    name = parse_tag_name()
    consume_char()
    value = parse_attr_value()
    return { name: name, value: value }
end function

function is_not_open_quote(current_char) as boolean:
    value = current_char <> m.open_quote
    return value
end function

function parse_attr_value() as string:
    m.open_quote = consume_char()
    return consume_while(is_not_open_quote)
end function

function parse_attributes() as object:
    attributes = {}
    while (true):
        if (next_char() = ">"):
            exit while
        end if
        consume_whitespace()
        print "parse_attributes,next_char=", next_char()
        attribute = parse_attr()
        attributes[attribute.name] = attribute.value
        consume_char()
    end while
    return attributes
end function

function parse_node() as object:
    next_char_value = next_char()
    if (next_char_value = "<") then
        return parse_element()
    else
        return create_web_text_node(parse_text())
    end if
end function

function parse_nodes(parser as object) as object:
    nodes = createObject("roArray", 10, true)
    m.parser = parser
    while true:
        consume_whitespace()
        nodes.Push(parse_node())
        if (eof()):
            exit while
        else if (starts_with("</"))
            exit while
        end if
    end while
    return nodes
end function

function parse_web(source as string) as object:
    parser = create_parser(1, source)
    nodes = parse_nodes(parser)
    return nodes
end function