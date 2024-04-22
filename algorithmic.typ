// SPDX-FileCopyrightText: 2023 Jade Lovelace
//
// SPDX-License-Identifier: MIT

/*
 * Generated AST:
 * (change_indent: int, body: ((ast | content)[] | content | ast)
 */

#let render_content(indent, content) = {
    pad(left: indent * 0.5em, content)
}

#let ast_to_content_list(indent, ast, meta: (:)) = {
    if type(ast) == "array" {
        ast.map(d => ast_to_content_list(indent, d, meta: meta))
    } else if type(ast) == "content" {
        ((content: render_content(indent, ast)) + meta,)
    } else if type(ast) == "dictionary" {
        let new_indent = ast.at("change_indent", default: 0) + indent
        ast_to_content_list(new_indent, ast.body, meta: ast.at("meta", default: (:)))
    }
}

#let algorithm(..bits) = {
    let content = bits.pos().map(b => ast_to_content_list(0, b)).flatten()
    let table_bits = ()
    let lineno = 1

    while lineno <= content.len() {
        table_bits.push([#lineno:])
        table_bits.push(content.at(lineno - 1).content)
        table_bits.push(content.at(lineno - 1).at("comment", default: []))
        lineno = lineno + 1
    }
    table(
        columns: (18pt, 70%, 30%),
        // line spacing
        inset: 0.3em,
        stroke: none,
        ..table_bits
    )
}

#let iflike_block(kw1: "", kw2: "", cond: "", ..body) = (
    (strong(kw1) + " " + cond + " " + strong(kw2)),
    // XXX: .pos annoys me here
    (change_indent: 4, body: body.pos())
)

#let function_like(name, kw: "function", args: (), ..body) = (
    iflike_block(kw1: kw, cond: (smallcaps(name) + "(" + args.join(", ") + ")"), ..body)
)

#let listify(v) = {
    if type(v) == "list" {
        v
    } else {
        (v,)
    }
}

#let Function = function_like.with(kw: "function")
#let Procedure = function_like.with(kw: "procedure")

#let State(block) = ((body: block),)

/// Inline call
#let CallI(name, args) = smallcaps(name) + "(" + listify(args).join(", ") + ")"
#let Call(..args) = (CallI(..args),)
#let FnI(f, args) = strong(f) + " (" + listify(args).join(", ") + ")"
#let Fn(..args) = (FnI(..args),)
#let Ic(c) = sym.triangle.stroked.r + " " + c
#let Cmt(c) = (Ic(c),)
// Trailing comment
#let Tc(line, c) = {
    assert.eq(type(line), "content", message: "Line of inline comment was not of type Content, but was " + type(line) + ", so it may span multiple lines. Use one of the 'I' functions to make an inline thing instead")
    ((body: line, meta: (comment: Ic(c))),)
}
// It kind of sucks that Else is a separate block but it's fine
#let If = iflike_block.with(kw1: "if", kw2: "then")
#let While = iflike_block.with(kw1: "while", kw2: "do")
#let For = iflike_block.with(kw1: "for", kw2: "do")
#let AssignI(var, val) = var + " " + $<-$ + " " + val
#let Assign(var, val) = (AssignI(var, val),)

#let Else = iflike_block.with(kw1: "else")
#let ElsIf = iflike_block.with(kw1: "else if", kw2: "then")
#let ElseIf = ElsIf
#let Return(arg) = (strong("return") + " " + arg,)
