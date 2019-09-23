function style_tree(root as object, stylesheet as object) as object:
    styledNode = {
        node: root,
    }
    if (root.node_type.element <> invalid) then
        styledNode.specified_values = {}
    else:
        styledNode.specified_values = {}
    end if
    children = createObject("roArray", 10, true)
    for each node in root.children:
        child = style_tree(node, stylesheet)
        children.push(child)
    end for
    return styledNode
end function


function build_layout_tree(style_node) as object:
    box_type = "block"
    root = create_layout_box({ node: style_node, type: box_type })
    ' if (style_node.display() = "block"):
    ' else if (style_node.display() = "inline"):
    ' else if (style.node.display() = "none")
    ' end if
    children = createObject("roArray", 10, true)
    for each child in style_node.children:
        children.push(build_layout_tree(child))
    end for
    root.children = children
    return root
end function



function create_layout_box(box_type as object) as object:
    return {
        box_type: box_type,
        dimensions: default_dimensions()
        children: createObject("roArray", 10, true)
    }
end function

function default_dimensions() as object:
    return {
        content: create_rect(0, 0, 0, 0),
        padding: create_edge_sizes(0, 0, 0, 0),
        border: create_edge_sizes(0, 0, 0, 0),
        margin: create_edge_sizes(0, 0, 0, 0),
    }
end function

function create_rect(x, y, width, height) as object:
    return {
        x: x,
        y: y,
        width: width,
        height: height,
    }
end function

function create_edge_sizes(left, right, top, bottom) as object:
    return {
        left: left,
        right: right,
        top: top,
        bottom: bottom,
    }
end function

sub render_text(layout_box as object)
    if (layout_box.box_type.node.node_type.text.trim() <> "")
        m.display_list.push({ text: layout_box.box_type.node.node_type.text, type: "text" })
    end if
end sub

sub render_layout_box(layout_box as object):
    render_text(layout_box)
    for each child in layout_box.children:
        render_layout_box(child)
    end for
end sub

function build_display_list(layout_root as object) as object:
    m.display_list = createObject("roArray", 10, true)
    render_layout_box(layout_root)
    return m.display_list
end function


function get_style_node() as object:

end function


function paint_item(item as object) as object:
    if item.type = "text"
        m.newItem = createObject("RoSGNode", "Label")
        regex = createObject("roRegex", "[\x0A\x0D\x09]", "i")
        m.newItem.text = regex.replaceAll(item.text.replace("&#39;", "´").replace("&quot;", """").replace("&mdash;", "—").replace("\xc2\xa0", "\x20"), " ").replace("&ndash;", "–").replace("&hellip;", "...")
        m.newItem.color = "0xFF0000"
        print "painting_item|", item
        if (m.top.getChildCount() > 0) then
            lastItemBoundingRect = m.top.getChild(m.top.getChildCount() - 1).boundingRect()
            ' m.newItem.translation = [0, lastItemBoundingRect.y + lastItemBoundingRect.height]
        end if
        test = m.top.findNode("test")
        test.appendChild(m.newItem)
        test.setFocus(true)
    end if
end function

function paint(layout_root as object, bounds as object):
    display_list = build_display_list(layout_root)
    for each item in display_list:
        paint_item(item)
    end for
end function