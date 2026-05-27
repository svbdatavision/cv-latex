# Packages needed: texlive-latex-base texlive-extra-utils texlive-lang-spanish texlive-lang-english

MAKEFLAGS += --no-builtin-rules --no-builtin-variables

SHELL := /bin/bash

TEX := pdflatex
TEX_OPTIONS := #-interaction=nonstopmode #-file-line-error
TEXFOT_OPTIONS := --quiet --tee /dev/null

CV_FOLDER := cv

# Load language-variety list after searching the folders in $(CV_FOLDER)
LANG_VARIETY_FOLDERS := $(shell find $(CV_FOLDER) -mindepth 2 -maxdepth 2 -type d)
LANGUAGE_VARIETY_LIST := $(subst /,-,$(LANG_VARIETY_FOLDERS:$(CV_FOLDER)/%=%))
# Check valid LANGUAGE_VARIETY_LIST.
$(foreach LANGUAGE_VARIETY,$(LANGUAGE_VARIETY_LIST),$(if $(findstring -,$(LANGUAGE_VARIETY)),,$(error Error in language variety: $(LANGUAGE_VARIETY))))

#LANGUAGE_LIST := $(foreach LANGUAGE_VARIETY,$(LANGUAGE_VARIETY_LIST),$(firstword $(subst -, ,$(LANGUAGE_VARIETY))))
#VARIETY_LIST := $(foreach LANGUAGE_VARIETY,$(LANGUAGE_VARIETY_LIST),$(lastword $(subst -, ,$(LANGUAGE_VARIETY))))

GENERIC := generic
CV_NAME := CV
CV_NAME_GENERIC := $(CV_NAME)_$(GENERIC)
CV_NAME_GENERIC_TEX := $(CV_NAME_GENERIC).tex
CV_NAME_GENERIC_INFO_TEX := $(CV_NAME_GENERIC)_info.tex
CV_OUTPUT_NAME_GENERIC := $(CV_NAME)_vonbergen_s

# Compiles CV's.
# It will be populated in make-cv_language-target.
.PHONY: all
all: bash_add_colors

# Allows colors in bash.
GREP_COLOR_INFO := 'ms=01;30:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'
GREP_COLOR_SUCCESSFULL := 'ms=01;32:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'
GREP_COLOR_ERROR := 'ms=01;31:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'
.PHONY: bash_add_colors
bash_add_colors:
	@./bash_add_colors.sh

# Create target files dynamically.
CV_OUTPUT_PDF_RELATIVE_PATHS_LIST :=
CV_OUTPUT_AUX_RELATIVE_PATHS_LIST :=
CV_OUTPUT_LOG_RELATIVE_PATHS_LIST :=
define make-cv_language_variety-target
  # Variables.
  $(eval LANGUAGE := $1)
  $(eval VARIETY := $2)
  $(eval CV_LANGUAGE_PATH := $(CV_FOLDER)/$(LANGUAGE))
  $(eval CV_LANGUAGE_VARIETY_PATH := $(CV_LANGUAGE_PATH)/$(VARIETY))
  $(eval CV_LANGUAGE_STY := $(CV_LANGUAGE_PATH)/$(LANGUAGE).sty)
  $(eval CV_LANGUAGE_VARIETY_TEX := $(CV_LANGUAGE_VARIETY_PATH)/$(VARIETY).tex)
  $(eval CV_OUTPUT_NAME := $(subst $(GENERIC),$(LANGUAGE)_$(VARIETY),$(CV_OUTPUT_NAME_GENERIC)))
  $(eval CV_OUTPUT_PATH := $(CV_LANGUAGE_VARIETY_PATH)/output)
  $(eval CV_OUTPUT_ABSOLUTE_PATH := $(CV_OUTPUT_PATH)/$(CV_OUTPUT_NAME))
  $(eval CV_OUTPUT_PDF_RELATIVE_PATHS_LIST += $(CV_OUTPUT_ABSOLUTE_PATH).pdf)
  $(eval CV_OUTPUT_AUX_RELATIVE_PATHS_LIST += $(CV_OUTPUT_ABSOLUTE_PATH).aux)
  $(eval CV_OUTPUT_LOG_RELATIVE_PATHS_LIST += $(CV_OUTPUT_ABSOLUTE_PATH).log)
  $(eval TEX_OUTPUT_OPTIONS := -output-directory $(CV_OUTPUT_PATH) -jobname=$(CV_OUTPUT_NAME))
  $(eval TEX_INPUT_OPTIONS := "\input{$(CV_LANGUAGE_VARIETY_TEX)} \input{$(CV_NAME_GENERIC_TEX)}")

  # Targets.
  all: $(CV_OUTPUT_ABSOLUTE_PATH).pdf
  $(CV_OUTPUT_ABSOLUTE_PATH).pdf: $(CV_NAME_GENERIC_TEX) $(CV_NAME_GENERIC_INFO_TEX) $(CV_FOLDER)/common.sty $(CV_LANGUAGE_STY)
	  @echo "-------------------------------------------------------------------------------------------------";
	  @echo "Compiling $${@F}:" | GREP_COLORS=$(GREP_COLOR_INFO) grep --color -E "(^|.*)";
	  @texfot $(TEXFOT_OPTIONS) $(TEX) $(TEX_OUTPUT_OPTIONS) $(TEX_OPTIONS) $(TEX_INPUT_OPTIONS) | ./texfot_color_output.sh;
	  @if [ -e "$${@}" ]; then \
		  texfot $(TEXFOT_OPTIONS) $(TEX) $(TEX_OUTPUT_OPTIONS) $(TEX_INPUT_OPTIONS) | ./texfot_color_output.sh; \
		  echo "$${@} was compiled successfully." | GREP_COLORS=$(GREP_COLOR_SUCCESSFULL) grep --color -E "(^|.*)"; \
	  else \
		  echo "$${@} was not compiled." | GREP_COLORS=$(GREP_COLOR_ERROR) grep --color -E "(^|.*)"; \
	  fi;
	  @echo "-------------------------------------------------------------------------------------------------";
endef

$(foreach \
  LANGUAGE_VARIETY,\
  $(LANGUAGE_VARIETY_LIST),\
  $(eval \
    $(call make-cv_language_variety-target,$(firstword $(subst -, ,$(LANGUAGE_VARIETY))),$(lastword $(subst -, ,$(LANGUAGE_VARIETY))))\
  )\
)

# Clean files.
.PHONY: clean
clean:
	rm -f $(CV_OUTPUT_PDF_RELATIVE_PATHS_LIST) $(CV_OUTPUT_AUX_RELATIVE_PATHS_LIST) $(CV_OUTPUT_LOG_RELATIVE_PATHS_LIST)
