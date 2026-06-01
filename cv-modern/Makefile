# Bilingual build for cv-modern (shared layout; language-specific content).
#
# Outputs:
#   build/en/CV_von_Bergen_Sebastian.pdf
#   build/es/CV_von_Bergen_Sebastian_es.pdf

TEX := pdflatex
TEXFLAGS := -interaction=nonstopmode -halt-on-error

JOBNAME_EN := CV_von_Bergen_Sebastian
JOBNAME_ES := CV_von_Bergen_Sebastian_es

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

LOGOS := $(wildcard assets/logos/*)
PHOTO := ../images/CV_photo.png

SHARED_DEPS := preamble.tex layout.sty $(LOGOS) $(PHOTO)

OUTDIR_EN := build/en
OUTDIR_ES := build/es
PDF_EN := $(OUTDIR_EN)/$(JOBNAME_EN).pdf
PDF_ES := $(OUTDIR_ES)/$(JOBNAME_ES).pdf

.PHONY: all en es clean distclean

all: en es

en: $(PDF_EN)

es: $(PDF_ES)

$(PDF_EN): main.en.tex $(SHARED_DEPS) $(EN_CONTENT)
	@mkdir -p $(OUTDIR_EN)
	$(TEX) $(TEXFLAGS) -output-directory=$(OUTDIR_EN) -jobname=$(JOBNAME_EN) main.en.tex

$(PDF_ES): main.es.tex $(SHARED_DEPS) $(ES_CONTENT)
	@mkdir -p $(OUTDIR_ES)
	$(TEX) $(TEXFLAGS) -output-directory=$(OUTDIR_ES) -jobname=$(JOBNAME_ES) main.es.tex

clean:
	rm -f $(OUTDIR_EN)/$(JOBNAME_EN).pdf $(OUTDIR_EN)/$(JOBNAME_EN).aux \
		$(OUTDIR_EN)/$(JOBNAME_EN).log $(OUTDIR_EN)/$(JOBNAME_EN).out
	rm -f $(OUTDIR_ES)/$(JOBNAME_ES).pdf $(OUTDIR_ES)/$(JOBNAME_ES).aux \
		$(OUTDIR_ES)/$(JOBNAME_ES).log $(OUTDIR_ES)/$(JOBNAME_ES).out
	@# Remove legacy output names from earlier builds (regenerable)
	rm -f $(OUTDIR_EN)/CV_Sebastian_AI_EN.pdf $(OUTDIR_EN)/CV_Sebastian_AI_EN.aux \
		$(OUTDIR_EN)/CV_Sebastian_AI_EN.log $(OUTDIR_EN)/CV_Sebastian_AI_EN.out
	rm -f $(OUTDIR_ES)/CV_Sebastian_AI_ES.pdf $(OUTDIR_ES)/CV_Sebastian_AI_ES.aux \
		$(OUTDIR_ES)/CV_Sebastian_AI_ES.log $(OUTDIR_ES)/CV_Sebastian_AI_ES.out

distclean:
	rm -rf build
