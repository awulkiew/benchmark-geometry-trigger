#!/bin/bash

# $1 - BENCHMARK_DIR
# $2 - BOOST_ROOT

pwd
ls

for f in `cat sha`; do

    echo "SHA: $f"

    # checkout the Boost.Geometry commit
    cd $2/libs/geometry && git checkout $f
    # update headers
    cd $2 && ./b2 headers

    # ./run.sh BOOST_ROOT TIMESTAMP SHA
    cd $1 && ./run.sh $2 `cd $2/libs/geometry && date -d"\`git show --quiet --format="%ci"\`" --utc +%Y.%m.%d-%H:%M:%S` $f

done

