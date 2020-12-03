#include <stdio.h>
#include <stdlib.h>
#include "./include/util.h"

unsigned int char_count (const char *, char, size_t length);

int main (int argc, const char* argv[])
{
  if (argc != 2) {
    die (1, "No input filename supplied!");
  }

  FILE * input_file = fopen (argv[1], "r");
  size_t buffer_size = 100;
  char * buffer = malloc (buffer_size * sizeof (char));

  int a, b;
  char c;
  char password[50];

  unsigned int count_part1 = 0;
  unsigned int count_part2 = 0;

  while (getline (&buffer, &buffer_size, input_file) > 0) {
    sscanf (buffer, "%d-%d %c:%s", &a, &b, &c, &password);

    int count = char_count (password, c, buffer_size);

    if (count >= a && count <= b) count_part1++;
    if ((password[a - 1] == c) ^ (password[b - 1] == c)) count_part2++;
  }

  free(buffer);

  printf("%d\n%d", count_part1, count_part2);

  return 0;
}

unsigned int char_count (const char * s, char c, size_t length)
{
  unsigned int count = 0;

  for (int i = 0; s[i] != '\0'; ++i) {
    if (s[i] == c) ++count;
  }

  return count;
}
