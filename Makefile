FILE := main
OUT  := build

.PHONY: pdf
pdf:
	+latexmk -interaction=nonstopmode -outdir="$(OUT)" -pdf -halt-on-error -jobname="$(jobname)" $(FILE)

.PHONY: watch
watch:
	+latexmk -interaction=nonstopmode -outdir="$(OUT)" -pdf -pvc -halt-on-error -jobname="$(jobname)" $(FILE)

# changes.pdf: the thesis with everything changed since the last review marked
# up (added text in blue, removed text struck out in red, with line numbers,
# see diff-preamble.tex). The baseline is the newest review-* tag. Override it
# with e.g. `make diff BASE=HEAD~3`. Requires latexdiff and git.
BASE ?= $(shell git describe --tags --abbrev=0 --match 'review-*' 2>/dev/null)

# latexdiff does not colour commands it does not know, so added or removed
# acronyms (\ac, \acp, \acs, ...) would stay unmarked. Their text is safe to wrap.
ACRONYM_CMDS := [Aa]c[slfp]?p?,[Ii]ac[slf]?

.PHONY: diff
diff:
	@test -n "$(BASE)" || { echo "No review-* tag found. Tag the reviewed commit or pass BASE=<rev>."; exit 1; }
	@rm -rf "$(OUT)/diff-base" && mkdir -p "$(OUT)/diff-base"
	git archive "$(BASE)" | tar -x -C "$(OUT)/diff-base"
	latexdiff --flatten --math-markup=whole --preamble=diff-preamble.tex \
		--append-safecmd="$(ACRONYM_CMDS)" --append-textcmd=acro \
		"$(OUT)/diff-base/$(FILE).tex" $(FILE).tex > "$(OUT)/changes.tex"
	@# The success_cmd in .latexmkrc (fachschaft_print.pdf) is for main.pdf only.
	+latexmk -interaction=nonstopmode -outdir="$(OUT)" -pdf -halt-on-error \
		-e '$$success_cmd = ""' "$(OUT)/changes.tex"

.PHONY: _fachschaft-print
_fachschaft-print:
	@if grep -sq '^TUM-Dev LaTeX-Thesis-Template: twoside$$' $(OUT)/$(FILE).log; then \
		if [ "$(OUT)/fachschaft_print.pdf" -nt "$(OUT)/$(FILE).pdf" ]; then \
			echo "fachschaft_print.pdf is up to date"; \
		else \
			echo "Building fachschaft_print.pdf..."; \
			if ! command -v pdfjam >/dev/null; then \
				echo "PDFJAM not installed. Can not build fachschaft_print.pdf."; \
				rm -f "$(OUT)/_fachschaft_print.pdf"; \
			else \
				pdfjam --twoside --a4paper -o "$(OUT)/fachschaft_print.pdf" "$(OUT)/$(FILE).pdf" 1,3-; \
			fi \
		fi \
	else \
		cp "$(OUT)/$(FILE).pdf" "$(OUT)/fachschaft_print.pdf"; \
	fi;

.PHONY: clean
clean:
	rm -rf $(filter-out $(wildcard $(OUT)/*.pdf), $(wildcard $(OUT)/*))

.PHONY: purge
purge:
	rm -rf $(OUT)
