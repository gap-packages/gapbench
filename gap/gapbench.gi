#
# gapbench: Benchmarking GAP
#
# Implementations
#

InstallGlobalFunction(MicroSeconds,
function()
    local t;
    t := CurrentTime();
    return t.tv_sec * 1000000 + t.tv_usec;
end);

InstallGlobalFunction(Bench,
function(f)
    local start, stop;
    start := MicroSeconds();
    f();
    stop := MicroSeconds();
    return (stop - start) * 1.0 / 1000000;
end);

InstallGlobalFunction(RepeatBench,
function(n, f)
    local res;

    res := List([1..n], x->Bench(f));

    return rec( res := res
              , avg := Average(res)
              , med := Median(res)
              , var := Variance(res)
              , min := Minimum(res)
              , max := Maximum(res)
           );
end);
