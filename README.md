game-of-life
============

Conway's game of life in Ada.  There are three version:

  1. a terminal version using the ncurses Ada binding (libncursesada3-dev on debian),
  2. a version using the Tcl Ada Shell binding to Tk (from http://tcladashell.sourceforge.net/), and
  3. a version that uses GTK (libgtkada2.24.4-dev on debian).

Key bindings in the terminal version:

w/a/s/d or cursor keys -  move the cursor around.
space - set the cell indicated by the cursor
ctrl-D - exits the game
any other key - generate the next cycle of life
