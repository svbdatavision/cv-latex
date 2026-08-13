# cv-modern

Bilingual CV (EN + ES) with shared `layout.sty` and `preamble.tex`.

Supports a second **expanded / ampliado** content variant (same design; denser technical experience and skills). Default builds remain the standard CVs.

## Build

```bash
make              # standard EN + ES (default; same as before)
make en           # standard English
make es           # standard Spanish
make expanded     # expanded EN + ES
make en-expanded  # Expanded CV (English)
make es-expanded  # CV ampliado (Spanish)
make everything   # standard + expanded (four PDFs)
make clean
make distclean
```

## Outputs

| Language | Variant | Path |
|----------|---------|------|
| English | Standard | `build/en/CV_von_Bergen_Sebastian.pdf` |
| Spanish | Standard | `build/es/CV_von_Bergen_Sebastian_es.pdf` |
| English | Expanded | `build/en/CV_von_Bergen_Sebastian_expanded.pdf` |
| Spanish | Ampliado | `build/es/CV_von_Bergen_Sebastian_es_ampliado.pdf` |

Content: `content/en/` and `content/es/` (mirrored structure). Expanded skills/experience live under `content/*/expanded/`. Photo: `../images/CV_photo.png`.
