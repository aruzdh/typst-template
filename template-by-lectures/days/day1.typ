#import "../lib.typ": *
#import "../bibliography/bibliography.bib": *

= Compsci Notes

#definition("Basis")[
  A *basis* $beta$ for a vector space $V$ is a linearly independent subset of $V$ that generates $V$. If $beta$ is a basis for $V$, we also say that the vectors of $beta$ form a basis for $V$.
] <def:basis>

#note[
  You should study linear algebra: #cite(<friedberg2018linear>, form: "prose")
]

== More Notes
#lorem(50)

#lorem(30)

#theorem(
  "Clairaut's theorem",
  footer: "This will be useful every time you want to interchange partial derivatives in the future."
  )[
  Let $f: A arrow RR$ with $A subset RR^n$ an open set such that its cross derivatives of any order exist and are continuous in $A$. Then for any point $(a_1, a_2, ..., a_n) in A$ it is true that

  $ frac(diff^n f, diff x_i ... diff x_j)(a_1, a_2, ..., a_n) = frac(diff^n f, diff x_j ... diff x_i)(a_1, a_2, ..., a_n) $
]


