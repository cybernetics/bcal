PREFIX ?= /usr/local
BINDIR = $(DESTDIR)$(PREFIX)/bin
MANDIR = $(DESTDIR)$(PREFIX)/share/man/man1
DOCDIR = $(DESTDIR)$(PREFIX)/share/doc/bcal

CFLAGS ?= -O3 -Wall -Wextra -Wno-unused-parameter -Werror
CFLAGS += -flto

SRC = $(wildcard src/*.c)
INCLUDE = -Iinc

bcal: $(SRC)
	$(CC) $(CFLAGS) $(INCLUDE) -o bcal $(SRC)
	strip bcal

all: bcal

x86: $(SRC)
	$(CC) -m64 $(CFLAGS) $(INCLUDE) -o bcal $(SRC)
	strip bcal

.PHONY: clean
clean:
	-rm -f bcal

distclean: clean
	rm -f *~

install: bcal
	install -m755 -d $(BINDIR)
	install -m755 -d $(MANDIR)
	install -m755 -d $(DOCDIR)
	install -m755 bcal $(BINDIR)
	gzip -c bcal.1 > bcal.1.gz
	install -m644 bcal.1.gz $(MANDIR)
	install -m644 README.md $(DOCDIR)
	rm -f bcal.1.gz

uninstall:
	rm -f $(BINDIR)/bcal
	rm -f $(MANDIR)/bcal.1.gz
	rm -rf $(DOCDIR)
