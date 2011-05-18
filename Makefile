ROCK := rock

override ROCKFLAGS += -g +-rdynamic -v

SOURCES := $(wildcard source/*) $(wildcard source/*/*)

spatula: $(SOURCES) Makefile
	$(ROCK) $(ROCKFLAGS) source/spatula.ooc

clean:
	rm -f spatula
	rm -rf rock_tmp

libsclean:
	rm -rf .libs/

.PHONY: clean libsclean
