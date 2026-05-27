#!/bin/bash
DEFAULT='ms=01;0:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'
BLACK='ms=01;30:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'
RED='ms=01;31:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'
GREEN='ms=01;32:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'
BLUE='ms=01;34:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'

# Errors to catch.
TEXFOT_START_PATTERNS="This is pdfTeX, Version .*|/usr/bin/texfot: invoking: pdflatex .*"
LATEX_WARNING_PATTERN="LaTeX Warning: .*|Overfull .*|Underfull .*"
LATEX_OUTPUT_PATTERN="Output written on .*"

while read line
do
	OUTPUT_ERROR=true
	if echo $line | GREP_COLORS=${BLUE} grep --color -E "(${LATEX_WARNING_PATTERN})"; then
		OUTPUT_ERROR=false
	elif echo $line | GREP_COLORS=${DEFAULT} grep --color -E "(${TEXFOT_START_PATTERNS}|${LATEX_OUTPUT_PATTERN})"; then
		OUTPUT_ERROR=false
	fi
	if ${OUTPUT_ERROR}; then
		echo $line | GREP_COLORS=${RED} grep --color -E "(^|.*)"
	fi
done
