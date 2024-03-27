#let conf(doc) = {
set page(numbering: "- 1/1 -")
set heading(numbering: "1.")
show link: underline
show link: set text(blue)
outline(title: [Inhaltsverzeichnis] )
doc
}
#let bracketed(content_before, content_after, height_lines, bracket : "}") = {
  table(
      columns : 3, 
      align: horizon,
      stroke: none,
      inset: 0em,
      column-gutter: 0.25em,
      content_before,
      scale(y: height_lines, bracket),
      content_after

  )
}
