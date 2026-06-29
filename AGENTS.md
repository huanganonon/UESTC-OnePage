# AGENTS.md

## Project

Typst source files for one-page exam cheat sheets ("一页纸开卷").
Each `.typ` file is a standalone document compiled to a `.pdf`.

## Build

Compile any file with:
```
typst compile <file>.typ [<output>.pdf]
```
`*.pdf` is in `.gitignore`; they are generated artifacts.

## Conventions

- Page dimensions and pre-printed stamp area coordinates are hardcoded at the top of each `.typ` file as variables (e.g. `real-width`, `stamp-top`).
- Two page-size presets exist:
  - `real-width: 192mm, real-height: 265mm` — used by `back.typ`, `circuit.typ`, `communication.typ`
  - `real-width: 210mm, real-height: 296mm` — used by `demo.typ`
- Font stack: Inter (latin-in-cjk) + Source Han Sans, with Microsoft YaHei and SimHei as fallbacks.
- Images live in `figures/`. Some filenames are Chinese; keep encoding in mind when adding new images.
- `assets/` is unused by the Typst sources currently.

## Notes

- No `typst.toml` or package manifest exists; this is not a Typst package.
- No test suite or CI is configured. Verification is visual (inspect the generated PDF).
- `demo2.typ` is a smaller example; `demo.typ` is the template reference.
