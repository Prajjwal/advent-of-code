#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>

_Noreturn void die (int code, const char * message)
{
  puts (message);
  exit (code);
}

double now ()
{
    struct timeval t;
    struct timezone tzp;
    gettimeofday (&t, &tzp);
    return t.tv_sec + t.tv_usec*1e-6;
}
