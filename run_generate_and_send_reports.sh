#!/bin/bash

# $1 - BENCHMARK_ROOT
# $2 - BOOST_ROOT

git config --global user.name "awulkiew-machine"
git config --global user.email "awulkiew.machine@gmail.com"
git config --global push.default simple

for i in `seq 1 5`; do

    pwd
    ls -lah

    # generate reports
    echo "Generate reports"
    for f in `cat $PROJECT_ROOT/sha`; do
        # generate report
        cd $1 && ./run_report.sh `cd $2/libs/geometry && date -d"\`git show --quiet --format="%ci"\`" --utc +%Y.%m.%d-%H:%M:%S` $f
    done

    echo "Push the reports"
    cd $1 && git add results
    cd $1 && git commit -m "`cat $PROJECT_ROOT/sha`"
    cd $1 && git push

    if [ $? -eq 0 ]; then
        echo "OK"
        exit 0
    elif [ $i -le 5 ]; then
        echo "Error. Cleanup and try again."
        echo "Reset"
        cd $1 && git reset HEAD^
        echo "Remove results"
        cd $1 && rm -Rf results/*
        echo "Checkout results"
        cd $1 && git checkout results
    fi

done

exit 1
