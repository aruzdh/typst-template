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
  paper_color: "#ffffff",
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
  accent: "#262626",
  colortab: false,
  // Table of Contents & Lists
  lof: false,
  lot: false,
  lol: false,
  body,
) = {
  // ====================
  // Initial Setup
  // ====================
  show: thmrules

  // Determine the accent color
  let accent_color = rgb(accent)

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
        (
          head_title
            + h(1fr)
            + emph(
              if current_heading.numbering != none {
                (
                  get_translation(translated_terms.at(h1-prefix))
                    + " "
                    + counter(heading.where(level: 1)).display("1: ")
                    + current_heading.body
                )
              } else {
                current_heading.body
              },
            )
        )
        v(-6pt) // Adjust vertical position for the line
        line(length: 100%, stroke: (thickness: 1pt, paint: accent_color, dash: "solid"))
      }
    },
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
  show selector(heading.where(level: 1)): set heading(numbering: (..nums) => (
    get_translation(translated_terms.at(h1-prefix)) + " " + nums.pos().map(str).join(".") + ":"
  ))

  // Disable numbering for specific major headings (e.g., Contents, References)
  show selector(heading.where(body: [#get_translation(translated_terms.contents)]))
    .or(heading.where(body: [#get_translation(translated_terms.lof)]))
    .or(heading.where(body: [#get_translation(translated_terms.lot)]))
    .or(heading.where(body: [#get_translation(translated_terms.lol)]))
    .or(heading.where(body: [#get_translation(translated_terms.references)])): set heading(numbering: none)

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
      authors
        .map(author => {
          text(11pt, weight: "semibold")[
            #if "link" in author {
              link(author.link)[#author.name]
            } else { author.name }
          ]
        })
        .join(", ", last: if authors.len() > 2 { ", and" } else { " and" })
    }))
  }
  v(6pt, weak: true)

  if date != none {
    align(center, table(
      columns: (auto, auto),
      stroke: none,
      gutter: 0pt,
      align: (right, left),
      [#text(size: 11pt, get_translation(translated_terms.created) + ":")],
      [#text(size: 11pt, fill: accent_color, weight: "semibold", date.display("[month] / [day] / [year repr:full]"))],

      [#text(size: 11pt, get_translation(translated_terms.last_updated) + ":")],
      [#text(
        size: 11pt,
        fill: accent_color,
        weight: "semibold",
        datetime.today().display("[month] / [day] / [year repr:full]"),
      )],
    ))
  } else {
    align(
      center,
      text(size: 11pt)[Last updated:#h(5pt)]
        + text(
          size: 11pt,
          fill: accent_color,
          weight: "semibold",
          datetime.today().display("[month] / [day] / [year repr:full]"),
        ),
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

#let horizontalrule(color: gray, dashed: false) = {
  line(
    length: 100%,
    stroke: (
      paint: color,
      thickness: 1pt,
      dash: if dashed { ("dot", 2pt, 4pt, 2pt) } else { none },
    ),
  )
}

// A math box command
#let mathbox(content, higher: false) = {
  box(
    stroke: 0.5pt,
    inset: (x: 2pt, y: 1pt),
    outset: (x: 1pt, y: if higher { 8pt } else { 3pt }),
    baseline: if higher { 6pt } else { 1pt },
    if higher { $display(#content)$ } else { $#content$ },
  )
}

// --- Theorem-like Environments ---

// General box
#let box(
  identifier,
  title,
  title-color: white,
  base-color,
  numbered: true,
  breakable: true,
) = thmenv(
  identifier,
  boxcounting,
  none,
  (name, number, body, ..args) => {
    showybox(
      breakable: breakable,
      frame: (
        border-color: base-color,
        title-color: base-color.lighten(30%),
        body-color: base-color.lighten(95%),
        footer-color: base-color.lighten(80%),
        radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt),
      ),
      title-style: (
        color: title-color,
        boxed-style: (
          anchor: (x: center, y: horizon),
          radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt),
        ),
      ),
      title: [
        #title #if numbered { number } else {} *#name*
      ],
      ..args.named(),
      body,
    )
  },
).with(numbering: boxnumbering)

// Core logical structures
#let theorem = box(
  "theorem",
  get_translation(translated_terms.theorem),
  black,
)

#let corollary = box(
  "corollary",
  get_translation(translated_terms.corollary),
  black,
)

#let lemma = box(
  "lemma",
  get_translation(translated_terms.lemma),
  black,
)

#let proposition = box(
  "proposition",
  get_translation(translated_terms.proposition),
  black,
)

#let hypothesis = box(
  "hypothesis",
  get_translation(translated_terms.hypothesis),
  black,
)

#let definition = box(
  "definition",
  get_translation(translated_terms.definition),
  black,
)

#let example = box(
  "example",
  get_translation(translated_terms.example),
  black,
)

#let note = box(
  "note",
  get_translation(translated_terms.note),
  black,
)

#let attention = box(
  "attention",
  get_translation(translated_terms.attention),
  rgb("#DC0000"),
)

#let important = box(
  "important",
  get_translation(translated_terms.important),
  rgb("#DC0000"),
)

#let exercise = box(
  "exercise",
  get_translation(translated_terms.exercise),
  black,
)

#let tip = box(
  "tip",
  get_translation(translated_terms.tip),
  title-color: black,
  numbered: false,
  rgb("#DC9900"),
)

// Miscellaneous
#let quote(cite: none, body) = [
  #set text(size: 0.97em)
  #pad(left: 1.5em)[
    #block(
      breakable: true,
      width: 100%,
      fill: gray.lighten(90%),
      radius: (left: 0pt, right: 5pt),
      stroke: (left: 5pt + gray, rest: 1pt + silver),
      inset: 1em,
    )[#body]
  ]
]

#let proof = (
  thmenv(
    "proof",
    boxcounting,
    none,
    (name, number, body, ..args) => {
      showybox(
        frame: (
          thickness: 0.5pt,
          title-color: white,
          border-color: black,
          body-color: rgb("#ffffff"),
          radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt),
        ),
        title-style: (
          color: black,
          boxed-style: (anchor: (x: left, y: horizon)),
        ),
        [*_#get_translation(translated_terms.proof)._*] + body + [#place(bottom + right, $qed$)],
      )
    },
  )
    .with(numbering(boxcounting))
    .with(numbering(boxcounting))
)

#let remark = (
  thmenv(
    "remark",
    boxcounting,
    none,
    (name, number, body, ..args) => {
      showybox(
        frame: (
          dash: "dashed",
          thickness: 0.5pt,
          title-color: white,
          border-color: black,
          body-color: rgb("#ffffff"),
          radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt),
        ),
        title-style: (
          color: black,
          boxed-style: (anchor: (x: left, y: horizon)),
        ),
        [*_#get_translation(translated_terms.remark)._*] + body,
      )
    },
  )
    .with(numbering(boxcounting))
    .with(numbering(boxcounting))
)

