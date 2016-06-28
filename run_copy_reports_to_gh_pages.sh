#!/bin/bash

# $1 - BENCHMARK_ROOT
# $2 - REPORTS_ROOT

#git config --global user.name "awulkiew-machine"
#git config --global user.email "awulkiew.machine@gmail.com"
#git config --global push.default simple

#cd $1 && git checkout master

cp $1/reports/* $2/

cd $1 && git checkout gh-pages
cd $1 && git pull

for i in `seq 1 5`; do

    echo "Copy reports to gh-pages"
    cd $1 && rm -f ./*.html
    cp $2/*.html $1/

    echo "Push gh-pages"
    cd $1 && git add -A .
    cd $1 && git commit -m "`cat $PROJECT_ROOT/sha`"
    cd $1 && git push

    if [ $? -eq 0 ]; then
        echo "OK"
        exit 0
    elif [ $i -le 5 ]; then
        echo "Cleanup"
        cd $1 && git reset HEAD^
        cd $1 && rm -f ./*.html
        cd $1 && git checkout .
        echo "Pull"
        cd $1 && git pull
    fi

done

exit 1
