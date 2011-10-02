OOC := rock

OOCFLAGS := -g +-rdynamic -v

SOURCES := $(shell find source/ -name '*.ooc')

spatula: $(SOURCES) Makefile
	$(OOC) $(OOCFLAGS) source/spatula.ooc

clean:
	rm -f spatula
	rm -rf rock_tmp

libsclean:
	rm -rf .libs/

.PHONY: clean libsclean
