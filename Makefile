Src=cocreport-v7
Name=15cocreport
Bib=refs.bib refs1.bib

all : dirs tex bib  tex tex embedfonts done

commit:
	svn commit -m stuff 
	svn commit -m stuff $(Bib)



publish : dirs all
	cp $(HOME)/tmp/$(Src).pdf pdf/$(Name).pdf
	chmod a+r pdf/$(Name).pdf
	scp -p pdf/$(Name).pdf stuff@ttoy.net:menzies.us/pdf

commit:; - git status; git commit -a; git push origin master
typo:  ; - git status; git commit -am "typo"; git push origin master
update:; - git pull origin master
status:; - git status
gitting:
	git config --global credential.helper cache
	git config credential.helper 'cache --timeout=3600'


view :
	evince $(HOME)/tmp/$(Src).pdf &

one : dirs tex done 

ready :
	mkdir -p $(HOME)/tmp

timm :
	cp $(HOME)/tmp/$(Src).pdf $(HOME)/public_html/tmp

done :
	@printf "\n\n\n==============================================\n"
	@printf       "see output in $(HOME)/tmp/$(Src).pdf\n"
	@printf       "==============================================\n\n\n"
	@printf "\n\nWarnings (may be none):\n\n"
	grep arning $(HOME)/tmp/${Src}.log

dirs : 
	- [ ! -d $(HOME)/tmp ] && mkdir $(HOME)/tmp
	- [ ! -d pdf ] && mkdir pdf

docx:
	pandoc  -s -S --biblio $(Bib) -csl ieee.csl $(Src).md -o $(Src).docx


tex : ready
	- pdflatex --shell-escape -output-directory=$(HOME)/tmp $(Src)

embedfonts:
	@ gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -sDEVICE=pdfwrite \
          -sOutputFile=$(HOME)/tmp/$(Src)-embedded.pdf $(HOME)/tmp/$(Src).pdf
	@ mv              $(HOME)/tmp/$(Src)-embedded.pdf $(HOME)/tmp/$(Src).pdf

bib : 
	- cp $(Bib) $(HOME)/tmp; cd $(HOME)/tmp; bibtex $(Src)
