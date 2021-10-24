LATEX = rapport.tex
ARCHIVE = snake.asm rapport.pdf
ARCHIVENAME = Beaurepere_Gall.tar.gz

latex: $(LATEX)
	@echo "------ MAKING LATEX ------"
	@pdflatex $(LATEX)

clean_latex:
	@echo "------ CLEANING LATEX ------"
	@rm *.aux 2> /dev/null || true
	@rm *.log 2> /dev/null || true
	@rm *.out 2> /dev/null || true
	@rm *.toc 2> /dev/null || true
	@rm *.mtc 2> /dev/null || true
	@rm *.mtc0 2> /dev/null || true
	@rm *.maf 2> /dev/null || true

dist:
	@echo "------ MAKING THE ARCHIVE ------"
	@tar -cvzf $(ARCHIVENAME) $(ARCHIVE)

clean_dist:
	@echo "------ CLEANING THE ARCHIVE ------"
	@rm $(ARCHIVENAME) 2> /dev/null || true

clean: clean_latex clean_dist