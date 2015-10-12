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


InstallGlobalFunction(GCBench,
function()
    local gc1, gc2, res1, res2;


    # This is bad for non-generational GCs
    gc1 := function()
        local i, t;
        for i in [1..100000000] do
            t := [i];               
        od;
    end;

    # This is bad for generational GCs
    gc2 := function()
        local i, j, t;
        for j in [1..100] do
            t := fail;
            for i in [1..1000000] do
                t := [t, t];
            od;
        od;
    end;    

    Print("running generational GC friendly test\n");
    res1 := RepeatBench(5, gc1);

    Print("running non-generational GC friendly test\n");
    res2 := RepeatBench(5, gc2);


    return([res1,res2]);
end);
