P=$1
OBJECTS=lib/util.o
CFLAGS = -g -Wall -O3 -std=gnu11
LDLIBS=
CC=gcc

day_01: $(OBJECTS) day_01.o
	gcc day_01.o lib/util.o -o day_01

clean:
	-find -type f -executable -print0 | xargs -0 rm
	-find -name "*.o" -print0 | xargs -0 rm
