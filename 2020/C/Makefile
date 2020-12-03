LIBS=lib/util.o
SOURCE_FILES=$(wildcard *.c)
OBJECTS=$(patsubst %.c,%.o,$(SOURCE_FILES))
TARGETS=$(patsubst %.c,%,$(SOURCE_FILES))
CFLAGS = -g -Wall -O3 -std=gnu11
LDLIBS=
CC=gcc

$(TARGETS): $(OBJECTS) $(LIBS)
	$(CC) $(CFLAGS) $@.o lib/util.o -o $@

clean:
	-find -type f -executable -print0 | xargs -0 rm
	-find -name "*.o" -print0 | xargs -0 rm
