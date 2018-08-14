# Exemple

Hi !

<!-- 
For italic, add one * on either side of the text
For bold, add two * on either side of the text
For bold and italic, add _** on either side of the text
-->

This is a brief outline of what went into each chapter. **Chapter 1** gives a background on duis tempus justo quis arcu consectetur sollicitudin.  **Chapter 2** discusses morbi sollicitudin gravida tellus in maximus.  **Chapter 3** discusses vestibulum eleifend turpis id turpis sollicitudin aliquet.  **Chapter 4** shows how phasellus gravida non ex id aliquet. Proin faucibus nibh sit amet augue blandit varius.



## Citation

To include a citation to the text, just add the citation key shown in the references.bib file. The style of the citation is determined by the ref.csl file. For example, in The Living Sea you can find pictures of the Calypso [@Cousteau1963].

## Footnote

iam plein text ^[i am a footnote]

## Syntax highlight

For syntax highlighting in code blocks, add three "\`" characters before and after a code block:

```python
mood = 'happy'
if mood == 'happy':
    print("I am a happy robot")
```

Alternatively, you can also use LaTeX to create a code block as shown in the Java example below:
\lstinputlisting[style=javaCodeStyle, caption=Main.java]{source/code/HelloWorld.java}

If you use `javaCodeStyle` as defined in the `preamble.tex`, it is best to keep the maximum line length in the source code at 80 characters.

## Equation

This is the literature review. Nullam quam odio, volutpat ac ornare quis, vestibulum nec nulla. Aenean nec dapibus in mL/min^-1^. Mathematical formula can be inserted using Latex:

(@ref_for_eqn1) $f(x) = ax^3 + bx^2 + cx + d$

$$f(x) = ax^3 + bx^2 + cx + d$$  {#eq:yourlabel}

$f(x) = ax^3 + bx^2 + cx + d$  {#eq:yourlabel}

Nunc eleifend, ex a luctus porttitor, felis ex suscipit tellus, ut sollicitudin sapien purus in libero. Nulla blandit eget urna vel tempus. Praesent fringilla dui sapien, sit amet egestas leo sollicitudin at.  

## Tables

---------------------------------------------------------------------------
Column 1            Column 2                Column 3
--------------      -------------------     -------------------
Row 1               0.1                     0.2

Row 2               0.3                     0.3

Row 3               0.4                     0.4      

Row 4               0.5                     0.6

---------------------------------------------------------------------------

## figure

Figure \ref{ref_a_figure} shows how to add a figure. Donec ut lacinia nibh. Nam tincidunt augue et tristique cursus. Vestibulum sagittis odio nisl, a malesuada turpis blandit quis. Cras ultrices metus tempor laoreet sodales. Nam molestie ipsum ac imperdiet laoreet. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.

<!-- 
Figures can be added with the following syntax:
![my_caption \label{my_label}](source/figures/my_image.pdf){ width=50% }

For details on setting attributes like width and height, see:
http://pandoc.org/MANUAL.html#extension-link_attributes
--> 

![RV Calypso is a former British Royal Navy minesweeper converted into a research vessel for the oceanographic researcher Jacques-Yves Cousteau. It was equipped with a mobile laboratory for underwater field research. \label{ref_a_figure}](source/figures/example_figure.pdf){ width=100% }




