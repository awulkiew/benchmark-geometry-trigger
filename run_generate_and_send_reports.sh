#!/bin/bash

# $1 - BENCHMARK_ROOT
# $2 - BOOST_ROOT
# $3 - RESULTS_ROOT
# $4 - PAGES_ROOT

git config --global user.name "awulkiew-machine"
git config --global user.email "awulkiew.machine@gmail.com"
git config --global push.default simple

status=1

for i in `seq 1 5`; do

    echo "Generate reports"
    for f in `cat $PROJECT_ROOT/sha`; do
		cd $2/libs/geometry && git checkout $f
        cd $1 && ./run_report.sh `cd $2/libs/geometry && date -d"\`git show --quiet --format="%ci"\`" --utc +%Y.%m.%d-%H:%M:%S` $f $3
    done

    mv $3/*.html $4/
    mv $3/*.js $4/
    mv $3/*.json $4/

    echo "Push results"
    cd $3 && git add . && git commit -m "`cat $PROJECT_ROOT/sha`" && git push
	status=$?
	
    if [ $status -eq 0 ]; then
        echo "Push gh-pages"
        cd $4 && git add . && git commit -m "`cat $PROJECT_ROOT/sha`" && git push
		status=$?
    fi

    if [ $status -eq 0 ]; then
        echo "OK"
        break
    elif [ $i -lt 5 ]; then
        echo "Cleanup results"
        cd $3 && git reset HEAD^ && rm -Rf * && git checkout . && git pull
        echo "Cleanup gh-pages"
        cd $4 && git reset HEAD^ && rm -Rf * && git checkout . && git pull
    fi

done

# generate artifacts for logging purposes
mkdir -p $CIRCLE_ARTIFACTS/results
cp -r $3/* $CIRCLE_ARTIFACTS/results/
mkdir -p $CIRCLE_ARTIFACTS/gh-pages
cp -r $4/* $CIRCLE_ARTIFACTS/gh-pages/
mkdir -p $CIRCLE_ARTIFACTS/temp
cp -r $BENCHMARK_ROOT/temp/* $CIRCLE_ARTIFACTS/temp/

exit $status
