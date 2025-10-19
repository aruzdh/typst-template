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

