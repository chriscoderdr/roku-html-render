function parse_stylesheet(source as string):
    parser = create_parser(1, source)
    m.parser = parser
    rules = parse_rules()
    print rules[1].selectors[0].selector
    return {
        rules: rules
    }
end function

function parse_rules() as object:
    rules = createObjecT("roArray", 26, true)
    while true
        consume_whitespace()
        if eof():
            exit while
        end if
        rules.Push(parse_rule())
    end while
    return rules
end function

function parse_rule() as object:
    rule = createObject("RoSGNode", "WebStylesheetRule")
    rule.selectors = parse_selectors()
    rule.declarations = parse_declarations()
    return rule
end function

function parse_declarations() as object:
    consume_char()
    declarations = createObjecT("roArray", 26, true)
    while true:
        consume_whitespace()
        if (next_char() = "}") then
            consume_char()
            exit while
        end if
        declarations.push(parse_declaration())
    end while
    return declarations
end function

function parse_declaration() as object:
    property_name = parse_identifier()
    consume_whitespace()
    consume_char()
    consume_whitespace()
    value = parse_value()
    consume_whitespace()
    consume_char()
    return {
        name: property_name,
        value: value
    }
end function

function parse_value() as object:
    next_char_value = next_char()
    regex = CreateObject("roRegex", "[0-9]", "i")
    if (regex.isMatch(next_char_value)) then
        return parse_length()
    else if (next_char_value = "#"):
        return parse_color()
    else
        return parse_identifier()
    end if
end function

function parse_length() as object:
    return [parse_float(), parse_unit()]
end function

function parse_float() as string:
    return consume_while(is_float)
end function

function is_float(char as string) as boolean:
    regex = CreateObject("roRegex", "[0-9.]", "i")
    return regex.isMatch(char)
end function

function parse_unit() as object:
    return parse_identifier()
end function


function parse_color() as object:
    consume_char()
    return {
        r: parse_hex_pair(),
        g: parse_hex_pair(),
        b: parse_hex_pair(),
        a: 255
    }
end function

function parse_hex_pair() as string:
    value = Mid(m.parser.input, m.parser.pos, 2)
    m.parser.pos += 2
    return value
end function



function parse_selectors() as object:
    selectors = createObject("roArray", 26, true)
    while (true)
        selectors.push({
            Selector: parse_simple_selector()
        })
        consume_whitespace()
        next_char_value = next_char()

        if (next_char_value = ",") then
            consume_char()
            consume_whitespace()
        else if (next_char_value = "{") then
            exit while
        end if
    end while
    return selectors

end function

function parse_simple_selector() as object:
    selector = createObject("RoSGNode", "SimpleSelector")
    class = createObject("roArray", 26, true)
    while true:
        if (eof()):
            exit while
        end if

        next_char_value = next_char()
        if (next_char_value = "#") then
            consume_char()
            selector.id = parse_identifier()
        else if (next_char_value = ".") then
            consume_char()
            class.push(parse_identifier())
        else if (next_char_Value = "*") then
            consume_char()
        else if (valid_identifier_char(next_char_value)) then
            selector.tag_name = parse_identifier()
        else
            exit while
        end if
    end while

    selector.class = class
    return selector
end function

function parse_identifier() as string:
    value = consume_while(valid_identifier_char)
    return value
end function


function valid_identifier_char(char as string) as boolean:
    regex = CreateObject("roRegex", "[a-zA-Z0-9-_]", "i")
    return regex.isMatch(char)
end function