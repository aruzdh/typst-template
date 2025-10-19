#import "./translated_terms.typ":*

// A minimal box to write a prove
#let proof(body) = [
  #block(
    inset: (left: 2em),
    [
    *_#get_translation(translated_terms.proof)._:*
    #body 
    #place(bottom + right, $qed$)
    ]
  )
]

// Use it to have a good text format inside a 'underbrace' or 'overbrace' function.
#let smash(body, side: center) = math.display(
  box(width: 0pt, align(
    side.inv(),
    box(width: float.inf * 1pt, $ script(body) $))
  )
)

// Make a title and subtitle
#let maketitle(title, subtitle: "", position: center) = [
  #align(position)[
    #text(18pt)[
      = #title
    ]

    #text(13pt, style: "italic")[
      #subtitle
    ]
  ]
]

// A nice horizontal line
#let horizontalrule(color: gray, dashed: false) = {
  line(
    length: 100%,
    stroke: (
      paint: color,
      thickness: 1pt,
      dash: if dashed { ("dot", 2pt, 4pt, 2pt) } else { none }
    )
  )
}

// A math box command
#let mathbox(content, higher: false) = {
  box(
    stroke: 0.5pt,
    inset: (x: 2pt, y: 1pt),
    outset: (x: 1pt, y: if higher { 8pt } else { 3pt }),
    baseline: if higher { 6pt } else { 1pt },
    if higher { $display(#content)$ } else { $#content$ }
  )
}

