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

InstallGlobalFunction(GCBenchGenerational,
function()
    local gc;

    # This is bad for non-generational GCs
    gc := function()
        local i, t;
        for i in [1..100000000] do
            t := [i];
        od;
    end;
    return RepeatBench(5, gc);
end);

InstallGlobalFunction(GCBenchNonGenerational,
function()
    local gc;

    # This is bad for generational GCs
    gc := function()
        local i, j, t;
        for j in [1..100] do
            t := fail;
            for i in [1..1000000] do
                t := [t, t];
            od;
        od;
    end;
    return RepeatBench(5, gc);
end);

InstallGlobalFunction(IntersectBench,
function()
    local f, p, g, h;

    p := (1,39,45,82,28,37,23,36,31,83,77,93,29,58,87,91,63,71,70,56,89,74,3,9,
          16,54,97,60,96,26,84,40,79,13,73,48,86,72,34,22,35,57,2,10,65,59,66)(4,
          92,81,12,21,64,42,25,88,85,33,100,49,24,20,76,8)(5,94,27,18,14,38)(6,53,
          98,51,67,99,17,78,68,19,11,52,32,75,47,41,7,95,46,62,43,50,44,55)(15,69,
          30,61,90);

    f := function()
        local g,h;
        g :=  DirectProduct(List([1..10], x -> AlternatingGroup(10)));
        h := g^p;
        Intersection(g,h);
    end;

    return RepeatBench(5, f);
end);

InstallGlobalFunction(RunAllBench,
function()
    Print("generational GC bench:\n", GCBenchGenerational(), "\n");
    Print("nongenerational GC bench:\n", GCBenchNonGenerational(), "\n");
    Print("group intersection bench:\n", IntersectBench(), "\n");
end);

