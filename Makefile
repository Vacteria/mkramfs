#!/usr/bin/make -f

CC = gcc
DESTDIR =
DATA = /lib/init/mkramfs
CONF = /etc
BIN  = /usr/bin

lsblock :
	$(CC) -lblkid -o lsblock lsblock.c

install :
	mkdir -p $(DESTDIR)/$(DATA) $(DESTDIR)/$(CONF) $(DESTDIR)/$(BIN)
	 
	for DIR in backend embedded live local init-functions; do \
		cp -avf $$DIR $(DESTDIR)/$(DATA)/; \
		find $(DESTDIR)/$(DATA)/ -type f -exec chmod 0644 {} \; ; \
		find $(DESTDIR)/$(DATA)/ -type d -exec chmod 0755 {} \; ; \
	done
	
	install -m 0644 mkramfs.conf $(DESTDIR)/$(CONF)
	install -m 0755 lsblock $(DESTDIR)/$(BIN)
	install -m 0755 mkramfs.in $(DESTDIR)/$(BIN)/mkramfs

clean :
	rm -f lsblock
