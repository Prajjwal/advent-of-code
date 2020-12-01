P=$1
OBJECTS=util.o
CFLAGS = -g -Wall -O3 -std=gnu11
LDLIBS=
CC=gcc

util.o:
	gcc -c lib/util.c -o lib/util.o

day_1: $(OBJECTS) day_1.o
	gcc day_1.o lib/util.o -o day_1

clean:
	-find -type f -executable -print0 | xargs -0 rm
	-find -name "*.o" -print0 | xargs -0 rm
