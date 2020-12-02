P=$1
OBJECTS=lib/util.o
CFLAGS = -g -Wall -O3 -std=gnu11
LDLIBS=
CC=gcc

day_1: $(OBJECTS) day_1.o
	gcc day_1.o lib/util.o -o day_1

clean:
	-find -type f -executable -print0 | xargs -0 rm
	-find -name "*.o" -print0 | xargs -0 rm
