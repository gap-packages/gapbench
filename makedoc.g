#
# gapbench: Benchmarking GAP
#
# This file is a script which compiles the package manual.
#
if fail = LoadPackage("AutoDoc", ">= 2014.03.27") then
    Error("AutoDoc version 2014.03.27 is required.");
fi;

AutoDoc( "gapbench" : scaffold := true, autodoc := true );

QUIT;
