#import "lib.typ": *

#show: template.with(
  title: [Usual Notes],
  short_title: "Usual Notes",
  description: [Usual description],
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
  accent: orange,
  colortab: true,
)

#include "./weeks/week1.typ"

