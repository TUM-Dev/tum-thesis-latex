FILE := main
OUT  := build

.PHONY: pdf
pdf:
	+latexmk -interaction=nonstopmode -outdir="$(OUT)" -pdf -halt-on-error -jobname="$(jobname)" $(FILE)

.PHONY: watch
watch:
	+latexmk -interaction=nonstopmode -outdir="$(OUT)" -pdf -pvc -halt-on-error -jobname="$(jobname)" $(FILE)

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
