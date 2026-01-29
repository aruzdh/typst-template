#import "lib.typ": *

#show: template.with(
  title: [Non-boring notes],
  short_title: "Usual Notes",
  description: [An usual description],
  date: datetime(year: 2025, month: 08, day: 11),
  authors: (
    (
      name: "Aru",
      link: "https://aruzdh.netlify.app",
    ),
  ),
  bibliography_file: "./bibliography/bibliography.bib",
  paper_size: "a4",
  cols: 1,
  h1-prefix: "lecture", // chapter or lecture
  text_lang: "en",
  accent: "#282828",
  colortab: true,
)

#include "./weeks/week1.typ"

