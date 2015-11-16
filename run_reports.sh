#!/bin/bash

# $1 - BENCHMARK_ROOT
# $2 - BOOST_ROOT

for f in `cat sha`; do

    # generate report
    cd $1 && ./run_report.sh `cd $2/libs/geometry && date -d"\`git show --quiet --format="%ci"\`" --utc +%Y.%m.%d-%H:%M:%S` $f

done

