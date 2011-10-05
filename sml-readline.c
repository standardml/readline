#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <readline/readline.h> 
#include <readline/history.h>	

/* This code is taken pretty much verbatim from the readline manual. */

/* A static variable for holding the line. */
static unsigned char *line_read = (char *)NULL;

/* Read a string, and return a pointer to it.
   Returns NULL on EOF. */
unsigned char *sml_rl_gets ( unsigned char *prompt )
{
  /* If the buffer has already been allocated,
     return the memory to the free pool. */
  if (line_read)
    {
      free (line_read);
      line_read = (unsigned char *)NULL;
    }

  /* Get a line from the user. */
  line_read = (unsigned char *)readline (prompt);

  return strdup(line_read);
}

