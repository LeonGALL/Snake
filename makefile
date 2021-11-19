LATEX = rapport.tex
ARCHIVE = snake.asm rapport.pdf
ARCHIVENAME = Beaurepere_Gall.tar.gz

latex: $(LATEX)
	@echo "------ MAKING LATEX ------"
	@pdflatex $(LATEX)

clean_latex:
	@echo "------ CLEANING LATEX ------"
	@rm -f *.aux
	@rm -f *.log
	@rm -f *.out
	@rm -f *.toc
	@rm -f *.mtc
	@rm -f *.mtc0
	@rm -f *.maf
	@rm -f *.fls
	@rm -f *.fdb_latexmk
	@rm -f *.synctex.gz

dist:
	@echo "------ MAKING THE ARCHIVE ------"
	@tar -cvzf $(ARCHIVENAME) $(ARCHIVE)

clean_dist:
	@echo "------ CLEANING THE ARCHIVE ------"
	@rm $(ARCHIVENAME) 2> /dev/null || true

clean: clean_latex clean_dist