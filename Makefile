# TARGETS:
#
#  distfiles  - generates a distfile
#
#  site       - generates a set of these pages with a customized header.
#                    make SITE=foo site
#               uses the file 'foo.html' as a header and puts the results
#               into 'foo/'

# note, this should be synchronized with 'index.html'
VER=1.6A

FILES=	README  ${HTMLFILES} ${IMAGES} mstrip.obj favicon.xpm

HTMLFILES=\
	copying.html \
	erinfo.html \
	index.html \
	rghinfo.html \
	rhoinfo.html \
	tmetinfo.html

IMAGES=	mstrip.gif  favicon.ico

distfiles: mcalc-$(VER).tar.gz

mcalc-$(VER).tar.gz:	$(FILES) Makefile
	mkdir mcalc-$(VER)
	cp -p $(FILES) mcalc-$(VER)
	tar -cvf - mcalc-$(VER) | gzip > mcalc-$(VER).tar.gz
	zip -r mcalc-$(VER).zip mcalc-$(VER)
	rm -fr mcalc-$(VER)
	@echo mcalc-$(VER).tar.gz is ready
	@echo mcalc-$(VER).zip is ready

favicon.ico: favicon.xpm
	xpmtoppm favicon.xpm | ppmtowinicon > $@

site: ${SITE} 

.PHONY : ${SITE}
${SITE}: ${FILES} ${SITE}.html Makefile
	test -f ${SITE}.html
	rm -fr $@
	mkdir $@
	cp upload $@
	cp ${IMAGES} $@
	for f in ${HTMLFILES} ; do \
		awk 'BEGIN{p=1} /^<\!--FOOTER-->/ {p=0} p==1 {print} ' $$f > $@/$$f ;\
		cat ${SITE}.html >> $@/$$f ;\
		awk 'BEGIN{p=0} p==1 {print} /^<\!--FOOTER-->/ {p=1} ' $$f >> $@/$$f ;\
	done

