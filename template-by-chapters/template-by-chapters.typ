#import "lib.typ": *

#show: template.with(
  title: [Non-boring notes],
  short_title: "Usual Notes",
  description: [An usual description],
  date: datetime(year: 1999, month: 12, day: 31),
  authors: (
    (
      name: "Aru",
      link: "https://aruzdh.netlify.app",
    ),
  ),
  bibliography_file: "./bibliography/bibliography.bib",
  paper_size: "a4",
  cols: 1,
  h1-prefix: "chapter", // chapter or lecture
  text_lang: "en",
  accent: maroon,
  colortab: true,
)

#include "./chapters/chapter1.typ"

