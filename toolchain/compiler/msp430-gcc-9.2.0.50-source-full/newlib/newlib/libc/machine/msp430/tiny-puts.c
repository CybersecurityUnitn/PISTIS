#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <newlib.h>

int write (int fd, const char *buf, int len);

int
_DEFUN(__wrap_puts, (s),
       char _CONST * s)
{
  int res = write (1, s, strlen (s));
  if (res == EOF)
  {
    write (1, "\n", 1);
    return EOF;
  }
  return write (1, "\n", 1);
}

int puts (char _CONST * s) __attribute__ ((weak, alias ("__wrap_puts")));
