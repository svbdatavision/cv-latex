# Minimal build for cv-modern (English scaffold only).

MAIN := main.en
JOBNAME := CV_Sebastian_AI_EN
OUTDIR := build/en
PDF := $(OUTDIR)/$(JOBNAME).pdf

TEX := pdflatex
TEXFLAGS := -interaction=nonstopmode -halt-on-error

CONTENT := \
	content/00-header.tex \
	content/10-summary.tex \
	content/20-skills.tex \
	content/30-experience.tex \
	content/40-education.tex \
	content/50-languages.tex

.PHONY: all clean distclean

all: $(PDF)

$(PDF): main.en.tex preamble.tex layout.sty $(CONTENT)
	@mkdir -p "$(OUTDIR)"
	$(TEX) $(TEXFLAGS) -output-directory="$(OUTDIR)" -jobname="$(JOBNAME)" "$(MAIN).tex"

clean:
	rm -f "$(OUTDIR)/$(JOBNAME).pdf" \
		"$(OUTDIR)/$(JOBNAME).aux" \
		"$(OUTDIR)/$(JOBNAME).log" \
		"$(OUTDIR)/$(JOBNAME).out"

distclean:
	rm -rf build
