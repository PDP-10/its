# Printing from ITS

Printing on ITS is usually a two-stage process: first you generate a
printable output file -- in XGP, SCAN or PRESS format -- from your
application, then you feed it to a printer spooler to get hardcopy.

In an emulated ITS system, we can use the printer spooler to produce
image files instead, which can be converted to a modern format (such as
PDF) on the host machine.

## How to print from...

### TJ6

TJ6 is a typesetting program, in the same tradition as TJ-2, RUNOFF
and roff. It justifies paragraphs of text, and produces output either
in plain text or XGP format. Here is a simple example of an XGP file:

```
.xgp
.font 0 times 12rom
.font 1 times 12bold
.twinch 4
.center
No. 1190. ^F1A Flan of Puff Paste.^F0

.adjust
Make half a pound of puff paste, roll twelve times till nearly worn
out, letting it remain some time on the slab before using; then have a
plain round or oval flan mould, butter the interior and line it with
the paste about one third of an inch in thickness, place a sheet of
white paper at the bottom and a band round the sides in the interior,
which fill with bread-crumbs, bake in a warm oven rather crisp, take
out, empty it of the bread-crumbs, and paper and turn it from your
mould, sift sugar all over and glaze with the salamander, serve filled
with any of the fruits dressed as directed for vol-au-vents. Should
you have any trimmings of paste left from a previous day it may be
used instead of making fresh.

(From Alexis Soyer, "The Gastronomic Regenerator".)
```

Save this file as `DEMO 1`, and format it with:

```
:tj6 demo
```

This will produce the printable XGP file `DEMO XGP`.

The TJ6 manual (which is itself a TJ6 document, `TJ6; TJ6MEM >`) is
available as
[AI Memo 358](http://bitsavers.org/pdf/mit/ai/aim/AIM-358.pdf).

### @

The @ program produces nicely-formatted listings of source code. It
understands several languages and has a wide variety of formatting
options.

To produce a cross-referenced listing of `GAMES; WUMPUS >`, do:

```
:@ /f[20fg,20fg,20vr]/-d/c games; wumpus
```

This will produce the printable XGP file `WUMPUS @XGP` in your user
directory.

The documentation for @ is available as `INFO; @ >`.

### SUDS

SUDS is a technical drawing system. The D program is the drawing
editor; it can produce output for a pen plotter, which the SCNV
program can convert into ITS SCAN format.

D is intended for use with a graphical display, but you don't need a
display in order to plot drawings. You may need to experiment with
scale and positioning to make the right part of the drawing visible,
though.

To plot `FOO DRW` into the pen plotter file `FOO PLT`:

```
:d
^Ci FOO DRW
^Fw FOO PLT
^Z:kill
```

To convert all `PLT` files in the current directory into printable
`SCN` files:

```
:scnv
```

For a quick reference to SUDS commands, see `DRAW; SUDS >`.

## Converting to a modern format

VERSA is a flexible printer spooler that can read XGP, SCAN and PRESS
files, and format them for Gould and Versatec printers. It can also
write "Harvard scan" compressed image files, which can be transported
to other systems for printing.

If you have a printable file produced by one of the applications
above, e.g. `WUMPUS @XGP`, do:

```
:versa wumpus @xgp
```

This will write a new image file `.TEMP.; HARSCN >`. (Note that the
`.TEMP.;` directory is cleaned out hourly by `TMPKIL`, so these files
will be removed automatically after a while.)

You now need to transfer `HARSCN 1` to your host machine. You can do
this by using image mode FTP, or by writing it to a tape and
extracting it with itstar (in which case say `-Wits` rather than
`-Wbin` below).

The `harscntopbm` program (in `tools/dasm`) converts Harvard scan
files into multi-image PBM files. If your printout is just a single
landscape page (e.g. a SUDS plot), then you can rotate it into the
correct orientation and convert it into a PNG image with a pipeline
like this:

```
harscntopbm -Wbin harscn.1 | pnmflip -r180 | pnmtopng >plot.png
```

If you printed multiple pages, you can split the output into one PBM
file per page like this:

```
harscntopbm -Wbin harscn.1 | pnmsplit - page%d.pbm
```

The `harscntopdf` script uses a more complex pipeline to convert
Harvard scan files into PDF files. It takes the same `-W` options as
`harscntopbm`, and the same `-r` options as `pnmflip`. To convert TJ6
or @ output to PDF, do:

```
harscntopdf -Wbin -r90 harscn.1 output.pdf
```
