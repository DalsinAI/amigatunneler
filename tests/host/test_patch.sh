#!/bin/sh
# Host test of amiga/patches: fetches upstream at the locked commit (or
# takes TU=), applies the patches (they must apply cleanly) and runs the
# C preprocessor over the patched files as the Amiga build sees them
# (__amigaos__ set; SDL's headers stood in for, as only the port's own
# lines are checked):
#  - the settings file is PROGDIR:Tunneler.prefs and $HOME is not read;
#  - a Workbench start (argc 0) gets an argument list of its own before
#    anything reads argv;
#  - the first window is 640 x 480;
# and over the Linux build, which must be as upstream had it.
#   sh tests/host/test_patch.sh
# Copyright (c) 2026 AmiCradle Team. GPL 2 or later, like SDL Tunneler.
set -eu
HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT=$(CDPATH= cd -- "$HERE/../.." && pwd)
. "$ROOT/package/tunneler.lock"
T=$(mktemp -d); trap 'rm -rf "$T"' EXIT
if [ -n "${TU:-}" ]; then
    mkdir -p "$T/tu"; cp -R "$TU/src" "$T/tu/"
else
    git -C "$T" init -q tu
    git -C "$T/tu" fetch -q --depth 1 "$TUNNELER_URL" "$TUNNELER_COMMIT"
    git -C "$T/tu" checkout -q FETCH_HEAD
fi
for p in "$ROOT"/amiga/patches/*.patch; do (cd "$T/tu" && patch -s -p1 --no-backup-if-mismatch < "$p"); done
mkdir -p "$T/stub/SDL"; : > "$T/stub/SDL/SDL.h"
pp() { ${CC:-cc} -E -P -I"$T/stub" -I"$T/tu/src" "$@" 2>/dev/null | tr -s ' \t\n' ' '; }
fails=0
check() { # what, text, pattern, expect (yes|no)
    if printf '%s' "$2" | grep -q -- "$3"; then got=yes; else got=no; fi
    if [ "$got" = "$4" ]; then echo "ok   $1"; else echo "FAIL $1"; fails=$((fails + 1)); fi
}
amain=$(pp -D__amigaos__ "$T/tu/src/main.c")
agfx=$(pp -D__amigaos__ "$T/tu/src/graphics.c")
lmain=$(pp "$T/tu/src/main.c")
lgfx=$(pp "$T/tu/src/graphics.c")
check "Amiga: settings in PROGDIR:Tunneler.prefs" "$amain" 'conffile = "PROGDIR:Tunneler.prefs";' yes
check "Amiga: \$HOME not read" "$amain" 'getenv( "HOME" )' no
check "Amiga: Workbench start gets its own argv first" "$amain" 'if( argc == 0 ) argv = wb_argv; argv0 = argv\[0\];' yes
check "Amiga: 640 x 480 window" "$agfx" 'int Video_X = 640; int Video_Y = 480;' yes
check "Linux: \$HOME as upstream" "$lmain" 'getenv( "HOME" )' yes
check "Linux: no Workbench argv" "$lmain" 'wb_argv' no
check "Linux: 800 x 600 as upstream" "$lgfx" 'int Video_X = 800; int Video_Y = 600;' yes
[ $fails = 0 ] && echo PASS || { echo "FAIL: $fails"; exit 1; }
