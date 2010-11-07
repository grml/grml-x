all: doc

doc: doc_man doc_html

doc_html: html-stamp

html-stamp: grml-x-legacy.html

doc_man: grml-x-legacy.1

%.1: %.txt
	asciidoc -d manpage -b docbook $<
	sed -i 's/<emphasis role="strong">/<emphasis role="bold">/' $*.xml
	xsltproc /usr/share/xml/docbook/stylesheet/nwalsh/manpages/docbook.xsl $*.xml
	# ugly hack to avoid duplicate empty lines in manpage
	# notice: docbook-xsl 1.71.0.dfsg.1-1 is broken! make sure you use 1.68.1.dfsg.1-0.2!
	cp $@ $@.tmp
	uniq $@.tmp > $@
	# ugly hack to avoid '.sp' at the end of a sentence or paragraph:
	sed -i 's/\.sp//' $@
	rm $@.tmp
	touch man-stamp

%.html: %.txt
	asciidoc -b xhtml11 $<
	touch html-stamp

online: doc
	scp grml-x-legacy.html grml:/var/www/grml/grml-x/index.html

clean:
	rm -rf grml-x-legacy.html grml-x-legacy.1 grml-x-legacy.xml html-stamp man-stamp
