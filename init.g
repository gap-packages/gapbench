#
# gapbench: Benchmarking GAP
#
# Reading the declaration part of the package.
#


# Legacy GAP compatibility shim
if not IsBound(Variance) then
    BindGlobal("Variance",
        function(l)
            local avg;
            avg := Average(l);
            return Average(List(l, x->(x-avg)^2));
        end);
fi;

if not IsBound(CurrentTime) then
    if IsBound(IO_gettimeofday) then
        BindGlobal("CurrentTime", IO_gettimeofday);
    else
        Error("Don't know a way to get time of day\n");
    fi;
fi;

ReadPackage( "gapbench", "gap/gapbench.gd");
