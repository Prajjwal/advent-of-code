#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <sys/time.h>

_Noreturn void die (int code, const char * message) {
  puts (message);
  exit (code);
}

double get_time()
{
    struct timeval t;
    struct timezone tzp;
    gettimeofday(&t, &tzp);
    return t.tv_sec + t.tv_usec*1e-6;
}

void pair_summing_to(int **, long long, int *);
void triplet_summing_to(int **, long long, int *);

int main (int argc, const char* argv[])
{
  if (argc != 2) {
    die (1, "No input filename supplied!");
  }

  size_t input_length = 200;
  int * input = malloc (input_length * sizeof (long));
  FILE * input_file = fopen (argv[1], "r");

  size_t buffer_length = 5;
  char * buffer = malloc (buffer_length * sizeof(char));
  char * parse_error_at = NULL;

  for (int i = 0; i < input_length; ++i) {
    if (getline(&buffer, &buffer_length, input_file) < 1) {
      die (2, "error reading input!");
    }

    input[i] = strtol (buffer, &parse_error_at, 10);
  }

  fclose(input_file);
  free (buffer);

  int * result_pair = malloc (2 * sizeof (int));
  double t1 = get_time ();
  pair_summing_to(&result_pair, 2020, input);
  double t2 = get_time ();
  printf ("[%d, %d] in [%lfs]\n", result_pair[0], result_pair[1], t2 - t1);
  free (result_pair);

  int * result_triplet = malloc (3 * sizeof (int));
  t1 = get_time ();
  triplet_summing_to(&result_triplet, 2020, input);
  t2 = get_time ();
  printf ("[%d, %d, %d] in %lfs\n", result_triplet[0], result_triplet[1], result_triplet[2], t2 - t1);
  free (result_triplet);

  free (input);

  return 0;
}

void pair_summing_to (int ** result_pair, long long target, int * input) {
  for (int i = 0; i < 200; ++i) {
    for (int j = 0; j < 200; ++j) {
      if (input[i] + input[j] == target) {
        (*result_pair)[0] = input[i];
        (*result_pair)[1] = input[j];
        return;
      }
    }
  }
}

void triplet_summing_to (int ** result_pair, long long target, int * input) {
  for (int i = 0; i < 200; ++i) {
    for (int j = 0; j < 200; ++j) {
      for (int k = 0; k < 200; ++k) {
        if (input[i] + input[j] + input[k] == target) {
          (*result_pair)[0] = input[i];
          (*result_pair)[1] = input[j];
          (*result_pair)[2] = input[k];
          return;
        }
      }
    }
  }
}
