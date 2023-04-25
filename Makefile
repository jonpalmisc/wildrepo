PREFIX		?= /usr/local

all: dist

.PHONY: dist
dist:
	poetry build

.PHONY: install
install:
	poetry install

.PHONY: install-wildclone
install-wildclone:
	install ./wildclone.sh $(PREFIX)/bin/wildclone

.PHONY: uninstall
uninstall:
	pip3 uninstall wildrepo

.PHONY: uninstall-wildclone
uninstall-wildclone:
	rm $(PREFIX)/bin/wildclone

.PHONY: clean
clean:
	rm -fr dist
