target = CESAR2012_paper

source = $(target).tex
latex_cmd = pdflatex
counter_file = build_counter.txt
pdf_file = $(target).pdf
bibtex_file = consolidated_bibtex_file.bib
bibtex_source = ../bibtex/consolidated_bibtex_source.bib

temporary_files = *.log *.aux *.out *.idx *.ilg *.bbl *.blg *.ind *.lof *.lot *.toc .pdf

all: $(pdf_file)

$(bibtex_file): $(bibtex_source)
	cp $(bibtex_source) $(bibtex_file)

$(pdf_file): $(source) Makefile $(bibtex_file)
	@echo $$(($$(cat $(counter_file)) + 1)) > $(counter_file)
	$(latex_cmd) $(source)
	bibtex $(target)
	if (grep "Warning" $(target).blg > /dev/null ) then false ; fi
	while ( \
		$(latex_cmd) $(target) ; \
		grep "Rerun to get" $(target).log > /dev/null \
	) do true ; done
	@echo "Build `cat $(counter_file)`"
	chmod a-x,a+r $(pdf_file)

vi:
	vi $(source)

spell:
	aspell --lang=EN_GB check $(source)

clean:
	rm -f $(temporary_files)

allclean: clean
	rm -f $(pdf_file)

