all: doc

doc: doc_man doc_html

doc_html: html-stamp

html-stamp: grml-x.txt
	asciidoc -b xhtml11 grml-x.txt
	touch html-stamp

doc_man: man-stamp

man-stamp: grml-x.txt
	asciidoc -d manpage -b docbook grml-x.txt
	sed -i 's/<emphasis role="strong">/<emphasis role="bold">/' grml-x.xml
	xsltproc /usr/share/xml/docbook/stylesheet/nwalsh/manpages/docbook.xsl grml-x.xml
	# ugly hack to avoid duplicate empty lines in manpage
	# notice: docbook-xsl 1.71.0.dfsg.1-1 is broken! make sure you use 1.68.1.dfsg.1-0.2!
	cp grml-x.1 grml-x.1.tmp
	uniq grml-x.1.tmp > grml-x.1
	# ugly hack to avoid '.sp' at the end of a sentence or paragraph:
	sed -i 's/\.sp//' grml-x.1
	rm grml-x.1.tmp
	touch man-stamp

online: doc
	scp grml-x.html grml:/var/www/grml/grml-x/index.html

clean:
	rm -rf grml-x.html grml-x.1 grml-x.xml html-stamp man-stamp
