/* The Amiga port's start: the stack and the version string.
 * Copyright (c) 2026 AmiCradle Team. GPL 2 or later, like SDL Tunneler. */

/* A Shell gives 4 KB of stack; SDL wants more. libnix's startup sets this
 * much up. */
unsigned long __stack = 128 * 1024;
static const char version[] __attribute__((used)) =
    "$VER: Tunneler 1.1.1 (16.11.2026)";
