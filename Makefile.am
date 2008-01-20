# version first -- they are parsed LTR and later options depend on automake 1.8
AUTOMAKE_OPTIONS = 1.8 dist-bzip2 no-dist-gzip

SUBDIRS = \
	bin \
	data \
	amik

release: dist
	make $(PACKAGE)-$(VERSION).tar.bz2.sha1

dist-hook: $(PACKAGE).spec
		cp $(top_srcdir)/$(PACKAGE).spec $(distdir)/$(PACKAGE).spec

# generate sha1sum sum files
%.sha1: %
	sha1sum $< > $@
