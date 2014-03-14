game-of-life
============

Conway's game of life in Ada.  There's a terminal version using the ncurses Ada binding
and a version using the Tcl Ada Shell binding to Tk.

Key bindings in the terminal version:

w/a/s/d or cursor keys -  move the cursor around.
space - set the cell indicated by the cursor
ctel-Z - was supposed to exit but seems to put it into the background (sigh)
any other key - generate the next cycle of life
