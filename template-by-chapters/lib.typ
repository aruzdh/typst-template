=
// Imports
// =============================================================
#import "translated_terms.typ": *
#import "@preview/showybox:2.0.3": showybox
#import "@preview/ctheorems:1.1.3": thmenv, thmrules

// =============================================================
// Template
// =============================================================
#let template(
  // Metadata
  title: "Lecture Notes Title",
  short_title: none,
  authors: (),
  description: none,
  date: none,

  // Document Layout
  paper_size: "a4",
  paper_color: "#ffffef",
  landscape: false,
  cols: 1,
  paragraph_indent: 1em,

  // Fonts & Language
  text_font: "STIXTwoText",
  code_font: "Iosevka",
  math_font: "STIX Two Math",
  text_lang: "en",

  // Numbering & References
  heading_numbering: "1.1",
  h1-prefix: "lecture",
  math_equation_numbering: none,
  bibliography_file: none,
  bibstyle: "apa",

  // Styling
  accent: "#DC143C",
  colortab: false,

  // Table of Contents & Lists
  lof: false,
  lot: false,
  lol: false,

  body
) = {
  // ====================
  // Initial Setup
  // ====================
  show: thmrules

  // Determine the accent color, ensuring it's a Typst color object
  let accent_color = {
    if type(accent) == str {
      rgb(accent)
    } else if type(accent) == "color" {
      accent
    } else {
      rgb("#DC143C") // Default accent
    }
  }

  // Construct a string title from the title content for metadata
  let str_title = ""
  if type(title) == content and title.has("children") {
    for element in title.children {
      if element.has("text") {
        str_title = str_title + element.text + " "
      }
    }
  } else if type(title) == str {
    str_title = title
  }
  str_title = str_title.trim(" ")

  // ====================
  // Global Set Rules
  // ====================

  // Set document metadata
  set document(title: str_title, author: authors.map(author => author.name))

  // Configure page layout and header
  set page(
    paper: paper_size,
    fill: rgb(paper_color),
    columns: cols,
    flipped: landscape,
    numbering: "1",
    number-align: center,
    header: context {
      let elems = query(selector(heading.where(level: 1)).before(here()))
      let head_title = text(fill: accent_color, {
        if short_title != none { short_title } else { str_title }
      })

      if elems.len() == 0 {
        align(right, "")
      } else {
        let current_heading = elems.last()
        // Display title on left, current heading on right
        head_title + h(1fr) + emph(
          if current_heading.numbering != none {
            get_translation(translated_terms.at(h1-prefix)) + " " + counter(heading.where(level: 1)).display("1: ") + current_heading.body
          } else {
            current_heading.body
          }
        )
        v(-6pt) // Adjust vertical position for the line
        line(length: 100%, stroke: (thickness: 1pt, paint: accent_color, dash: "solid"))
      }
    },
    // Optional background color tab
    background: if colortab {
      place(
        top + right,
        rect(
          fill: gradient.linear(angle: 45deg, white, accent_color),
          width: 100%,
          height: 1em
        )
      )
    } else { none }
  )

  // Set fonts, language, and paragraph style
  set text(font: text_font, size: 10pt, lang: text_lang)
  set par(justify: true, linebreaks: "optimized", leading: 1em, first-line-indent: paragraph_indent)
  
  // Set numbering formats
  set heading(numbering: heading_numbering)
  set math.equation(numbering: math_equation_numbering)

  // Configure list indentation
  set enum(indent: 10pt, body-indent: 6pt)
  set list(indent: 10pt, body-indent: 6pt)

  // ====================
  // Global Show Rules
  // ====================

  // Style headings
  show heading: it => {
    it
    v(12pt, weak: true)
  }

  // Configure level 1 heading numbering format
  show selector(heading.where(level: 1)): set heading(numbering:
    (..nums) => get_translation(translated_terms.at(h1-prefix))
      + " " + nums.pos().map(str).join(".") + ":"
  )

  // Disable numbering for specific major headings (e.g., Contents, References)
  show selector(heading.where(body: [#get_translation(translated_terms.contents)]))
    .or(heading.where(body: [#get_translation(translated_terms.lof)]))
    .or(heading.where(body: [#get_translation(translated_terms.lot)]))
    .or(heading.where(body: [#get_translation(translated_terms.lol)]))
    .or(heading.where(body: [#get_translation(translated_terms.references)])
  ): set heading(numbering: none)

  // Style math equations and fonts
  show math.equation: set text(font: math_font)
  show math.equation: eq => {
    set block(spacing: 1.5em)
    eq
  }

  // Style inline and block code
  show raw: set text(font: code_font)
  show raw.where(block: false): it => box(fill: luma(236), inset: (x: 2pt), outset: (y: 3pt), radius: 1pt)[#it]

  // Configure figure captions and spacing
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: raw): it => {
    v(0.5em)
    it
    v(0.5em)
  }

  // Style links, except for author names
  show link: it => {
    let author_names = authors.map(author => author.name)
    if it.body.has("text") and it.body.text in author_names {
      it // Display author links as-is
    } else {
      // Other links are underlined, dotted, offset, and colored
      underline(stroke: (dash: "densely-dotted"), offset: 2pt, text(fill: accent_color, it))
    }
  }

  // Style outline entries (Table of Contents)
  show outline.entry: it => {
    text(fill: accent_color, it)
  }

  // ====================
  // Document Structure
  // ====================

  // --- Title Page ---
  align(center, [
    #set text(18pt, weight: "bold")
    #title
  ])

  if description != none {
    align(center, box(width: 90%)[
      #set text(size: 12pt, style: "italic")
      #description
    ])
  }
  v(18pt, weak: true)

  if authors.len() > 0 {
    align(center, box(inset: (y: 10pt), {
      authors.map(author => {
        text(11pt, weight: "semibold")[
          #if "link" in author {
            link(author.link)[#author.name]
          } else { author.name }
        ]
      }).join(", ", last: if authors.len() > 2 { ", and" } else { " and" })
    }))
  }
  v(6pt, weak: true)

  if date != none {
    align(center, table(
      columns: (auto, auto), stroke: none, gutter: 0pt, align: (right, left),
      [#text(size: 11pt, get_translation(translated_terms.created) + ":")],
      [#text(size: 11pt, fill: accent_color, weight: "semibold", date.display("[month] / [day] / [year repr:full]"))],
      [#text(size: 11pt, get_translation(translated_terms.last_updated) + ":")],
      [#text(size: 11pt, fill: accent_color, weight: "semibold", datetime.today().display("[month] / [day] / [year repr:full]"))],
    ))
  } else {
    align(center,
      text(size: 11pt)[Last updated:#h(5pt)] +
      text(size: 11pt, fill: accent_color, weight: "semibold", datetime.today().display("[month] / [day] / [year repr:full]"))
    )
  }
  v(18pt, weak: true)

  // --- Table of Contents and Lists ---
  heading(level: 1, outlined: false)[#get_translation(translated_terms.contents)]
  outline(indent: auto, title: none)

  if lof or lot or lol {
    show heading.where(level: 1): set text(size: 0.9em)
    if lof {
      v(4pt)
      heading(level: 1)[#get_translation(translated_terms.lof)]
      outline(indent: auto, title: none, target: figure.where(kind: image))
    }
    if lot {
      v(4pt)
      heading(level: 1)[#get_translation(translated_terms.lot)]
      outline(indent: auto, title: none, target: figure.where(kind: table))
    }
    if lol {
      v(4pt)
      heading(level: 1)[#get_translation(translated_terms.lol)]
      outline(indent: auto, title: none, target: figure.where(kind: raw))
    }
    align(center)[#v(1em) * \* #sym.space.quad \* #sym.space.quad \* *]
  }

  v(2em, weak: true)

  // --- Main Body ---
  body

  // --- Bibliography ---
  if bibliography_file != none {
    v(24pt, weak: true)
    align(center)[#v(0.5em) * \* #sym.space.quad \* #sym.space.quad \* * #v(0.5em)]
    bibliography(bibliography_file, title: [#get_translation(translated_terms.references)], style: bibstyle)
  }
}

// =============================================================
// Boxes, Rules, and Environments
// =============================================================

// Default numbering settings for theorem environments
#let boxnumbering = "1.1.1.1.1.1"
#let boxcounting = "heading"

// General purpose boxes and rules
#let blockquote(cite: none, body) = [
  #set text(size: 0.97em)
  #pad(left: 1.5em)[
    #block(
      breakable: true,
      width: 100%,
      fill: gray.lighten(90%),
      radius: (left: 0pt, right: 5pt),
      stroke: (left: 5pt + gray, rest: 1pt + silver),
      inset: 1em
    )[#body]
  ]
]

#let horizontalrule = {
  v(1em)
  line(start: (37%, 0%), end: (63%, 0%), stroke: 0.5pt)
  v(1em)
}

#let sectionline = align(center)[#v(0.5em) * \* #sym.space.quad \* #sym.space.quad \* * #v(0.5em)]

// LaTeX-style boxed math commands
#let iboxed(content) = {
  box(stroke: 0.5pt, outset: (x: 1pt, y: 3pt), inset: (x: 2pt, y: 1pt), baseline: 1pt, $#content$)
}
#let dboxed(content) = {
  box(stroke: 0.5pt, outset: (x: 1pt, y: 8pt), inset: (x: 2pt, y: 1pt), baseline: 6pt, $display(#content)$)
}

// --- Theorem-like Environments ---

// Core logical structures
#let theorem = thmenv(
  "theorem", boxcounting, none, (name, number, body, ..args) => {
    showybox(
      frame: (border-color: navy, title-color: navy.lighten(30%), body-color: navy.lighten(95%), footer-color: navy.lighten(80%), radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt)),
      title-style: (boxed-style: (anchor: (x: center, y: horizon), radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt))),
      title: [#get_translation(translated_terms.theorem) #number *#name*], ..args.named(), body
    )
  }
).with(numbering: boxnumbering)

#let corollary = thmenv(
  "corollary", boxcounting, none, (name, number, body, ..args) => {
    showybox(
      frame: (border-color: navy, title-color: navy.lighten(30%), body-color: navy.lighten(95%), footer-color: navy.lighten(80%), radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt)),
      title-style: (boxed-style: (anchor: (x: center, y: horizon), radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt))),
      title: [#get_translation(translated_terms.corollary) #number *#name*], ..args.named(), body
    )
  }
).with(numbering: boxnumbering)

#let lemma = thmenv(
  "lemma", boxcounting, none, (name, number, body, ..args) => {
    showybox(
      frame: (border-color: fuchsia, title-color: fuchsia.lighten(30%), body-color: fuchsia.lighten(95%), footer-color: fuchsia.lighten(80%), radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt)),
      title-style: (boxed-style: (anchor: (x: center, y: horizon), radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt))),
      title: [#get_translation(translated_terms.lemma) #number *#name*], ..args.named(), body
    )
  }
).with(numbering: boxnumbering)

#let proposition = thmenv(
  "proposition", boxcounting, none, (name, number, body, ..args) => {
    showybox(
      frame: (border-color: maroon, title-color: maroon.lighten(30%), body-color: maroon.lighten(95%), footer-color: maroon.lighten(80%), radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt)),
      title-style: (boxed-style: (anchor: (x: center, y: horizon), radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt))),
      title: [#get_translation(translated_terms.proposition) #number *#name*], ..args.named(), body
    )
  }
).with(numbering: boxnumbering)

#let hypothesis = thmenv(
  "hypothesis", boxcounting, none, (name, number, body, ..args) => {
    showybox(
      frame: (border-color: maroon, title-color: maroon.lighten(30%), body-color: maroon.lighten(95%), footer-color: maroon.lighten(80%), radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt)),
      title-style: (boxed-style: (anchor: (x: center, y: horizon), radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt))),
      title: [#get_translation(translated_terms.hypothesis) #number *#name*], ..args.named(), body
    )
  }
).with(numbering: boxnumbering)

#let definition = thmenv(
  "definition", boxcounting, none, (name, number, body, ..args) => {
    showybox(
      frame: (border-color: red, title-color: red.lighten(30%), body-color: red.lighten(95%), footer-color: red.lighten(80%), radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt)),
      title-style: (boxed-style: (anchor: (x: center, y: horizon), radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt))),
      title: [#get_translation(translated_terms.definition) #number *#name*], ..args.named(), body
    )
  }
).with(numbering: boxnumbering)

// Explanatory elements
#let example = thmenv(
  "example", boxcounting, 0, (name, number, body, ..args) => {
    showybox(
      frame: (border-color: orange, title-color: orange.lighten(30%), body-color: orange.lighten(95%), footer-color: orange.lighten(80%), radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt)),
      title-style: (boxed-style: (anchor: (x: center, y: horizon), radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt))),
      title: [#get_translation(translated_terms.example) #number *#name*], ..args.named(), body
    )
  }
).with(numbering: boxnumbering)

#let note = thmenv(
  "note", boxcounting, none, (name, number, body, ..args) => {
    showybox(
      frame: (border-color: eastern, title-color: eastern.lighten(30%), body-color: eastern.lighten(95%), footer-color: eastern.lighten(80%), radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt)),
      title-style: (boxed-style: (anchor: (x: center, y: horizon), radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt))),
      title: [#get_translation(translated_terms.note) *#name*], ..args.named(), body
    )
  }
).with(numbering: boxnumbering)

// Attention-grabbing elements
#let attention = thmenv(
  "attention", boxcounting, none, (name, number, body, ..args) => {
    showybox(
      frame: (border-color: rgb("#DC143C"), title-color: rgb("#DC143C").lighten(30%), body-color: rgb("#DC143C").lighten(95%), footer-color: rgb("DC143C").lighten(80%), radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt)),
      title-style: (boxed-style: (anchor: (x: center, y: horizon), radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt))),
      title: [#get_translation(translated_terms.attention) *#name*], ..args.named(), body
    )
  }
).with(numbering: boxnumbering)

#let important = thmenv(
  "important", boxcounting, none, (name, number, body, ..args) => {
    showybox(
      frame: (border-color: rgb("#DC143C"), title-color: rgb("#DC143C").lighten(30%), body-color: rgb("#DC143C").lighten(95%), footer-color: rgb("DC143C").lighten(80%), radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt)),
      title-style: (boxed-style: (anchor: (x: center, y: horizon), radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt))),
      title: [#get_translation(translated_terms.important) *#name*], ..args.named(), body
    )
  }
).with(numbering: boxnumbering)

#let exercise = thmenv(
  "exercise", boxcounting, 0, (name, number, body, ..args) => {
    showybox(
      frame: (border-color: olive, title-color: olive.lighten(30%), body-color: blue.lighten(95%), footer-color: olive.lighten(80%), radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt)),
      title-style: (boxed-style: (anchor: (x: center, y: horizon), radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt))),
      title: [#get_translation(translated_terms.exercise) #number *#name*], ..args.named(), body
    )
  }
).with(numbering: boxnumbering)

// Miscellaneous
#let quote = thmenv(
  "quote", boxcounting, none, (name, number, body, ..args) => {
    showybox(
      frame: (border-color: black, title-color: black.lighten(30%), body-color: black.lighten(95%), footer-color: black.lighten(80%), radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt)),
      title-style: (boxed-style: (anchor: (x: center, y: horizon), radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt))),
      title: [#get_translation(translated_terms.quote) #number *#name*], ..args.named(), body
    )
  }
).with(numbering: boxnumbering)

#let tip = thmenv(
  "tip", boxcounting, none, (name, number, body, ..args) => {
    showybox(
      frame: (border-color: yellow, title-color: yellow.lighten(30%), body-color: yellow.lighten(95%), footer-color: yellow.lighten(80%), radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt)),
      title-style: (color: black, boxed-style: (anchor: (x: center, y: horizon), radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt))),
      title: [#get_translation(translated_terms.tip) *#name*], ..args.named(), body
    )
  }
).with(numbering: boxnumbering)

#let proof = thmenv(
"proof", boxcounting, none, (name, number, body, ..args) => {
  showybox(
    frame: (
      dash: "dashed",
      thickness:0.5pt,
      title-color:white,
      border-color: black,
      body-color: rgb("#ffffef"),
      radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt)
    ),
    title-style: (
      color: black,
      boxed-style: (anchor: (x: left, y: horizon))
    ),
    [*_#get_translation(translated_terms.proof)._*] + body + [#place(bottom + right, $qed$)]
  )
}
).with(numbering(boxcounting)).with(numbering(boxcounting))

#let remark = thmenv(
"remak", boxcounting, none, (name, number, body, ..args) => {
  showybox(
    frame: (
      thickness:0.5pt,
      title-color:white,
      border-color: black,
      body-color: rgb("#ffffef"),
      radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt)
    ),
    title-style: (
      color: black,
      boxed-style: (anchor: (x: left, y: horizon))
    ),
    [*_#get_translation(translated_terms.remark)._*] + body
  )
}
).with(numbering(boxcounting)).with(numbering(boxcounting))

