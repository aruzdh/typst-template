#import "./translated_terms.typ":*

#let dem(body) = [
  #block(
    inset: (left: 2em),
    [
    *_#get_translation(translated_terms.proof)._:*
    #body 
    #place(bottom + right, $qed$)
    ]
  )
]

#let smash(body, side: center) = math.display(
  box(width: 0pt, align(
    side.inv(),
    box(width: float.inf * 1pt, $ script(body) $))
  )
)

