#!/bin/bash

NAME=paper

BASEDIR="./"
INPUTDIR=$BASEDIR/source
OUTPUTDIR=$BASEDIR/output
TEMPLATEDIR=$INPUTDIR/templates
STYLEDIR=$BASEDIR/style
BIBFILE=$INPUTDIR/references.bib

#PANDOC_FLAGS="-s -N --template=style/template.tex -f markdown+yaml_metadata_block+tex_math_dollars -t latex"
#BIBLIO_FLAGS="--bibliography=source/references.bib --csl=style/ref.csl"
#YAML_METADATA=config.yaml
PANDOC_FLAGS="-t latex \
    -H $STYLEDIR/preamble.tex \
	--template=$STYLEDIR/template.tex  \
	--bibliography=$BIBFILE\
	-V papersize=a4paper \
	-V documentclass=report \
	-N \
	--verbose \
	--filter pandoc-eqnos \
	--filter pandoc-citeproc \
	--highlight-style pygments \
	--csl=$STYLEDIR/ref.csl" 

echo '\\iffalse' >> extra_ref.md
# find [@...] markdowns. Note that there can be multiple @... inside a bracket. We don't care, just replace the whole if they are not converted. 1) use sed to put each citation markdown in one line 2) find those lines using grep 3) remove the text after the citation markdowns 3) make the mapping. keys are put inside a table to not be converted using pandoc, values are just ordinary citation markdowns. I use 1::-- and 0::-- to recognize the map later in the .tex
sed source/[^_]*.md  -e 's/\(\[@\)/\n\1/g' |grep '\[[@a-zA-Z0-9_,\:\-\ ;]*\]'|  sed -e 's/.*\(\[[@a-zA-Z0-9_,\:\-\ ;]*\]\).*/\1/g' | sed -e 's/\[//g' -e 's/\]//g' | sed -e 's/\(.*\)/\\begin\{table\}1::-- \1\\end\{table\} 0::-- \[\1\]\n/g' >> extra_ref.md
echo '\\fi' >> extra_ref.md

pandoc $PANDOC_FLAGS $YAML_METADATA source/[^_]*.md  extra_ref.md  >$NAME.tex

#bring them back. It needs another .sh file if you use it in a MakeFile because it seems that sed labeling doesn't work in MakeFiles
#put the mapping in a temp file, find the mapping using grep.  Sed expressions are to remove table environment, remove mapping arrow, concat lines (pandoc breaks lines after tables)!
grep '::--' ${NAME}.tex | sed -e 's/\\begin{table}1::-- \([@a-zA-Z0-9_,\:\-\ ;]*\)\\end{table}.*/\1/g' -e 's/0::-- //g' | sed -e ':a;N;$!ba;s/\(.\)\n\({\)/\1 \2/g' > temp.txt


#for each unresolved citation. Use grep to find lines with [@....], remove texts before and after it. remove [], 
for l in `sed ${NAME}.tex  -e 's/\(\[@\)/\n\1/g' | grep '\[[@a-zA-Z0-9_,\:\-\ ;]*\]'|  sed -e 's/.*\(\[[@a-zA-Z0-9_,\:\-\ ;]*\]\).*/\1/g' | sed -e 's/\[//g' -e 's/\]//g' | grep '@'`;
do
       #find in the mapping and replace it
        v=`grep $l temp.txt | head -n 1 | cut -f 2- -d{`;
        sed -i  ${NAME}.tex -e "s/\[$l\]/{$v/g";
done

rm temp.txt

#run pdflatex here
