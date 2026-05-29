# Bilingual build for cv-modern (shared layout; language-specific content).

TEX := pdflatex
TEXFLAGS := -interaction=nonstopmode -halt-on-error

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

PDF_EN := build/en/CV_Sebastian_AI_EN.pdf
PDF_ES := build/es/CV_Sebastian_AI_ES.pdf

.PHONY: all en es clean distclean

all: en es

en: $(PDF_EN)

es: $(PDF_ES)

$(PDF_EN): main.en.tex $(SHARED_DEPS) $(EN_CONTENT)
	@mkdir -p build/en
	$(TEX) $(TEXFLAGS) -output-directory=build/en -jobname=CV_Sebastian_AI_EN main.en.tex

$(PDF_ES): main.es.tex $(SHARED_DEPS) $(ES_CONTENT)
	@mkdir -p build/es
	$(TEX) $(TEXFLAGS) -output-directory=build/es -jobname=CV_Sebastian_AI_ES main.es.tex

clean:
	rm -f build/en/CV_Sebastian_AI_EN.pdf build/en/CV_Sebastian_AI_EN.aux \
		build/en/CV_Sebastian_AI_EN.log build/en/CV_Sebastian_AI_EN.out
	rm -f build/es/CV_Sebastian_AI_ES.pdf build/es/CV_Sebastian_AI_ES.aux \
		build/es/CV_Sebastian_AI_ES.log build/es/CV_Sebastian_AI_ES.out

distclean:
	rm -rf build
