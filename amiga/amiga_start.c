/* The Amiga port's start: the stack and the version string.
 * Copyright (c) 2026 AmiCradle Team. GPL 2 or later, like SDL Tunneler. */

/* A Shell gives 4 KB of stack; SDL wants more. libnix's startup sets this
 * much up. */
unsigned long __stack = 128 * 1024;
static const char version[] __attribute__((used)) =
    "$VER: Tunneler 1.1.1 (16.11.2026)";

/* LAB TRACE ONLY (team3/tunneler-lab-trace-20261116): not for the PR. */
#include <stdio.h>
#include <stdlib.h>
void tu_trace(const char *s)
{
    FILE *f = fopen("PROGDIR:trace.txt", "a");
    if (f) { fputs(s, f); fputc('\n', f); fclose(f); }
}
static void tu_trace_last(void) { tu_trace("atexit last (after every SDL_Quit)"); }
__attribute__((constructor)) static void tu_trace_init(void)
{
    tu_trace("start");
    atexit(tu_trace_last);
}
