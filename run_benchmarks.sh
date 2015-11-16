#!/bin/bash

# $1 - BENCHMARK_ROOT
# $2 - BOOST_ROOT

for f in `cat sha`; do

    echo "SHA: $f"

    # checkout the Boost.Geometry commit
    cd $2/libs/geometry && git checkout $f
    # update headers
    cd $2 && ./b2 headers

    # run benchmarks
    cd $1 && ./run_benchmarks.sh $2 $f

done

