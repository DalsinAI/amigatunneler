SDL Tunneler for GFOS
=====================

A port of SDL Tunneler, Taneli Kalvas's remake of Geoffrey Silverton's
DOS game Tunneler, from https://github.com/guyromm/tunneler at commit
a49c95106e1018be6a9778078fa533ae0df87c20 (version 1.1.1), for GFOS:
AmigaOS 3.2 with GFOpenUp, on a 68040 or 68060 with an FPU, on GFOpenUp's
SDL 2 through sdl12-compat.

Two tanks, one keyboard, a split screen: dig through the earth, find the
other tank and destroy it. Or play the computer (-ai 1).

Status: built in Cradle's os32-gcc16-open6 stove; not yet run in a lab.


What you need
-------------

- GFOS: AmigaOS 3.2 with GFOpenUp 0.8.26 or later, which installs
  LIBS:GFOpenGPU/SDL2.module.
- A 68040 or 68060 with an FPU (not an LC040 or EC040), an RTG screen
  with room for a 640 x 480 window (or the AmiCradle lab), and about 2 MB
  of free memory.


How to play
-----------

Install it one of three ways:

- GFOpenUp: `GFOpenUpTool INSTALL Parts/Tunneler` puts it in
  SYS:Games/Tunneler.
- Run Install-Tunneler from the archive (it offers Work:Games).
- Or copy the Tunneler drawer where you want it.

Then double-click Tunneler. The keys are in the drawer's Controls file.
The settings are kept in the drawer's Tunneler.prefs; Install-Tunneler
keeps it when it updates the game.


Building
--------

    sh package/build-amiga.sh        (STOVE=/path/to/os32-gcc16-open6)

or, in Cradle, stove_build with the os32-gcc16-open6 stove and target
package. It fetches upstream at the commit package/tunneler.lock names,
applies amiga/patches, builds with amiga/Makefile.amigaos and packs
Tunneler-VERSION-68040.lha and the GFOpenUp part Parts/Tunneler.

Host test: `sh tests/host/test_patch.sh` applies the patch to upstream
and checks the Amiga build's preprocessed code: a Workbench start
(argc 0) reads no arguments, the settings file is PROGDIR:Tunneler.prefs
and the window 640 x 480, while the Linux build stays as upstream.


What was changed
----------------

- amiga/patches/0001-amigaos.patch: the settings in
  PROGDIR:Tunneler.prefs (no $HOME); a Workbench start reads no
  arguments; a 640 x 480 window at first (800 x 600 upstream), which a
  68040 draws quicker.
- amiga/amiga_start.c: 128 KB of stack, the $VER string.
- amiga/Makefile.amigaos: -fgnu89-inline, for upstream's 2004 GNU inline
  function.
- amiga/: the Makefile, the GlowIcons (our own art), the Installer script
  and its spec. package/: the build, the release archive and the GFOpenUp
  part.

The AmiCradle Team.
