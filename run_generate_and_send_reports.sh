#!/bin/bash

# $1 - BENCHMARK_ROOT
# $2 - BOOST_ROOT
# $3 - RESULTS_ROOT
# $4 - PAGES_ROOT

git config --global user.name "awulkiew-machine"
git config --global user.email "awulkiew.machine@gmail.com"
git config --global push.default simple

for i in `seq 1 5`; do

    pwd
    ls -lah

    echo "Generate reports"
    for f in `cat $PROJECT_ROOT/sha`; do
        cd $1 && ./run_report.sh `cd $2/libs/geometry && date -d"\`git show --quiet --format="%ci"\`" --utc +%Y.%m.%d-%H:%M:%S` $f $3
    done

    mv $3/*.html $4/

    echo "Push results"
    cd $3 && git add . && git commit -m "`cat $PROJECT_ROOT/sha`" && git push

    if [ $? -eq 0 ]; then
        echo "Push gh-pages"
        cd $4 && git add . && git commit -m "`cat $PROJECT_ROOT/sha`" && git push
    fi

    if [ $? -eq 0 ]; then
        echo "OK"
        # generate artifacts for logging purposes
        mkdir -p $CIRCLE_ARTIFACTS/results
        cp $3/*.txt $CIRCLE_ARTIFACTS/results/
        mkdir -p $CIRCLE_ARTIFACTS/results-html
        cp $4/*.html $CIRCLE_ARTIFACTS/results-html/
        mkdir -p $CIRCLE_ARTIFACTS/temp
        cp $BENCHMARK_ROOT/temp/* $CIRCLE_ARTIFACTS/temp/
        exit 0
    elif [ $i -le 5 ]; then
        echo "Cleanup results"
        cd $3 && git reset HEAD^ && rm -Rf * && git checkout . && git pull
        echo "Cleanup gh-pages"
        cd $4 && git reset HEAD^ && rm -Rf * && git checkout . && git pull
    fi

done

exit 1
