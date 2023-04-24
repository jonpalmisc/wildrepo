PREFIX		?= /usr/local

all: dist

.PHONY: dist
dist:
	poetry build

.PHONY: install
install:
	poetry install
	install ./wildclone.sh $(PREFIX)/bin/wildclone

.PHONY: uninstall
uninstall:
	pip3 uninstall wildrepo
	rm $(PREFIX)/bin/wildclone

.PHONY: clean
clean:
	rm -fr dist
