# Bilingual build for cv-modern (shared layout; language-specific content).
#
# Outputs (standard — default):
#   build/en/CV_von_Bergen_Sebastian.pdf
#   build/es/CV_von_Bergen_Sebastian_es.pdf
#
# Outputs (expanded / ampliado):
#   build/en/CV_von_Bergen_Sebastian_expanded.pdf
#   build/es/CV_von_Bergen_Sebastian_es_ampliado.pdf
#
# Usage:
#   make                 # standard EN + ES (default; unchanged)
#   make en / make es
#   make expanded        # expanded EN + ES
#   make en-expanded / make es-expanded
#   make everything      # standard + expanded (four PDFs)

TEX := pdflatex
TEXFLAGS := -interaction=nonstopmode -halt-on-error

JOBNAME_EN := CV_von_Bergen_Sebastian
JOBNAME_ES := CV_von_Bergen_Sebastian_es
JOBNAME_EN_EXPANDED := CV_von_Bergen_Sebastian_expanded
JOBNAME_ES_EXPANDED := CV_von_Bergen_Sebastian_es_ampliado

CONTENT_BASENAMES := \
	00-header.tex \
	10-summary.tex \
	20-skills.tex \
	30-experience.tex \
	40-education.tex \
	50-languages.tex \
	55-community.tex

EN_CONTENT := $(addprefix content/en/,$(CONTENT_BASENAMES))
ES_CONTENT := $(addprefix content/es/,$(CONTENT_BASENAMES))

# Expanded variant: dedicated header/summary/skills/experience + shared education/languages/community.
EN_EXPANDED_CONTENT := \
	content/en/expanded/00-header.tex \
	content/en/expanded/10-summary.tex \
	content/en/expanded/20-skills.tex \
	content/en/expanded/30-experience.tex \
	content/en/40-education.tex \
	content/en/50-languages.tex \
	content/en/55-community.tex

ES_EXPANDED_CONTENT := \
	content/es/expanded/00-header.tex \
	content/es/expanded/10-summary.tex \
	content/es/expanded/20-skills.tex \
	content/es/expanded/30-experience.tex \
	content/es/40-education.tex \
	content/es/50-languages.tex \
	content/es/55-community.tex

LOGOS := $(wildcard assets/logos/*)
PHOTO := ../images/CV_photo.png

SHARED_DEPS := preamble.tex layout.sty $(LOGOS) $(PHOTO)
EXPANDED_DEPS := preamble.expanded.tex $(SHARED_DEPS)

OUTDIR_EN := build/en
OUTDIR_ES := build/es
PDF_EN := $(OUTDIR_EN)/$(JOBNAME_EN).pdf
PDF_ES := $(OUTDIR_ES)/$(JOBNAME_ES).pdf
PDF_EN_EXPANDED := $(OUTDIR_EN)/$(JOBNAME_EN_EXPANDED).pdf
PDF_ES_EXPANDED := $(OUTDIR_ES)/$(JOBNAME_ES_EXPANDED).pdf

.PHONY: all standard expanded en es en-expanded es-expanded everything clean distclean

# Default keeps historical behavior: standard bilingual CVs only.
all: en es
standard: all

en: $(PDF_EN)
es: $(PDF_ES)

expanded: en-expanded es-expanded
en-expanded: $(PDF_EN_EXPANDED)
es-expanded: $(PDF_ES_EXPANDED)

# Convenience: generate all four PDFs (standard + expanded).
everything: all expanded

$(PDF_EN): main.en.tex $(SHARED_DEPS) $(EN_CONTENT)
	@mkdir -p $(OUTDIR_EN)
	$(TEX) $(TEXFLAGS) -output-directory=$(OUTDIR_EN) -jobname=$(JOBNAME_EN) main.en.tex

$(PDF_ES): main.es.tex $(SHARED_DEPS) $(ES_CONTENT)
	@mkdir -p $(OUTDIR_ES)
	$(TEX) $(TEXFLAGS) -output-directory=$(OUTDIR_ES) -jobname=$(JOBNAME_ES) main.es.tex

$(PDF_EN_EXPANDED): main.en.expanded.tex $(EXPANDED_DEPS) $(EN_EXPANDED_CONTENT)
	@mkdir -p $(OUTDIR_EN)
	$(TEX) $(TEXFLAGS) -output-directory=$(OUTDIR_EN) -jobname=$(JOBNAME_EN_EXPANDED) main.en.expanded.tex

$(PDF_ES_EXPANDED): main.es.expanded.tex $(EXPANDED_DEPS) $(ES_EXPANDED_CONTENT)
	@mkdir -p $(OUTDIR_ES)
	$(TEX) $(TEXFLAGS) -output-directory=$(OUTDIR_ES) -jobname=$(JOBNAME_ES_EXPANDED) main.es.expanded.tex

clean:
	rm -f $(OUTDIR_EN)/$(JOBNAME_EN).pdf $(OUTDIR_EN)/$(JOBNAME_EN).aux \
		$(OUTDIR_EN)/$(JOBNAME_EN).log $(OUTDIR_EN)/$(JOBNAME_EN).out
	rm -f $(OUTDIR_ES)/$(JOBNAME_ES).pdf $(OUTDIR_ES)/$(JOBNAME_ES).aux \
		$(OUTDIR_ES)/$(JOBNAME_ES).log $(OUTDIR_ES)/$(JOBNAME_ES).out
	rm -f $(OUTDIR_EN)/$(JOBNAME_EN_EXPANDED).pdf $(OUTDIR_EN)/$(JOBNAME_EN_EXPANDED).aux \
		$(OUTDIR_EN)/$(JOBNAME_EN_EXPANDED).log $(OUTDIR_EN)/$(JOBNAME_EN_EXPANDED).out
	rm -f $(OUTDIR_ES)/$(JOBNAME_ES_EXPANDED).pdf $(OUTDIR_ES)/$(JOBNAME_ES_EXPANDED).aux \
		$(OUTDIR_ES)/$(JOBNAME_ES_EXPANDED).log $(OUTDIR_ES)/$(JOBNAME_ES_EXPANDED).out
	@# Remove legacy output names from earlier builds (regenerable)
	rm -f $(OUTDIR_EN)/CV_Sebastian_AI_EN.pdf $(OUTDIR_EN)/CV_Sebastian_AI_EN.aux \
		$(OUTDIR_EN)/CV_Sebastian_AI_EN.log $(OUTDIR_EN)/CV_Sebastian_AI_EN.out
	rm -f $(OUTDIR_ES)/CV_Sebastian_AI_ES.pdf $(OUTDIR_ES)/CV_Sebastian_AI_ES.aux \
		$(OUTDIR_ES)/CV_Sebastian_AI_ES.log $(OUTDIR_ES)/CV_Sebastian_AI_ES.out

distclean:
	rm -rf build
