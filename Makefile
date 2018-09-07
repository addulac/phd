PY=python3
PANDOC=pandoc

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/source
OUTPUTDIR=$(BASEDIR)/output
TEMPLATEDIR=$(INPUTDIR)/templates
STYLEDIR=$(BASEDIR)/style
BIBFILE=$(INPUTDIR)/references.bib

#PDF_ENGINE=xelatex
PDF_ENGINE=pdflatex

help:
	@echo ' 																	  '
	@echo 'Makefile for the Markdown thesis                                       '
	@echo '                                                                       '
	@echo 'Usage:                                                                 '
	@echo '   make html                        generate a web version             '
	@echo '   make pdf                         generate a PDF file  			  '
	@echo '   make docx	                       generate a Docx file 			  '
	@echo '   make tex	                       generate a Latex file 			  '
	@echo '                                                                       '
	@echo ' 																	  '
	@echo ' 																	  '
	@echo 'get local templates with: pandoc -D latex/html/etc	  				  '
	@echo 'or generic ones from: https://github.com/jgm/pandoc-templates		  '

pdf:
	pandoc "$(INPUTDIR)"/[^_]*.md \
	-o "$(OUTPUTDIR)/thesis.pdf" \
	-H "$(STYLEDIR)/preamble.tex" \
	--template="$(STYLEDIR)/template.tex" \
	--bibliography="$(BIBFILE)" 2>pandoc.log \
	-V papersize=a4paper \
	-V documentclass=report \
	-N \
	--verbose \
	--pdf-engine=$(PDF_ENGINE) \
	--filter pandoc-eqnos \
	--filter pandoc-citeproc \
	--highlight-style pygments \
	--csl="$(STYLEDIR)/ref.csl" \

tex:
	pandoc "$(INPUTDIR)"/[^_]*.md \
	-o "$(OUTPUTDIR)/thesis.tex" \
	-H "$(STYLEDIR)/preamble.tex" \
	--bibliography="$(BIBFILE)" \
	-V fontsize=12pt \
	-V papersize=a4paper \
	-V documentclass=report \
	-N \
	--csl="$(STYLEDIR)/ref.csl" \
	--latex-engine=xelatex \
	--filter pandoc-eqnos
	
final:
	./resolv_md.sh 2>pandoc.log
	pdflatex thesis.tex

docx:
	pandoc "$(INPUTDIR)"/[^_]*.md \
	-o "$(OUTPUTDIR)/thesis.docx" \
	--bibliography="$(BIBFILE)" \
	--csl="$(STYLEDIR)/ref.csl" \
	--toc \
	--filter pandoc-eqnos

html:
	pandoc "$(INPUTDIR)"/[^_]*.md \
	-o "$(OUTPUTDIR)/thesis.html" \
	--standalone \
	--template="$(STYLEDIR)/template.html" \
	--bibliography="$(BIBFILE)" \
	--csl="$(STYLEDIR)/ref.csl" \
	--include-in-header="$(STYLEDIR)/style.css" \
	--toc \
	--number-sections \
	--mathjax \
	--filter pandoc-eqnos
	rm -rf "$(OUTPUTDIR)/source"
	mkdir "$(OUTPUTDIR)/source"
	cp -r "$(INPUTDIR)/figures" "$(OUTPUTDIR)/source/figures"

clean:
	find -name "*.dvi" -delete
	find -name "*.log" -delete
	find -name "*.lot" -delete
	find -name "*.lof" -delete
	find -name "*.aux" -delete
	find -name "*.toc" -delete
	find -name "*.out" -delete
	find -name "*.bbl" -delete
	find -name "*.blg" -delete
	find -name "*.nav" -delete
	find -name "*.snm" -delete
	find -name "*.vrb" -delete
	find -name "*.fls" -delete
	find -name "*.fls" -delete
	find -name "*.synctex.gz" -delete
	find -name "*.fdb_latexmk" -delete


.PHONY: help pdf docx html tex
