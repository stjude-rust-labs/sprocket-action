#!/bin/bash

lint=$1
exclusions=$2

if [ ! -z "$exclusions" ]; then
    echo "Exclusions provided. Writing to .sprocket.yml."
    echo -n "" > .sprocket.yml
    for exclusion in $(echo $exclusions | sed 's/,/ /')
    do
        echo "$exclusion" >> .sprocket.yml
    done
fi

EXITCODE=0

echo "Checking WDL files using \`sprocket lint\`."
for file in $(find $GITHUB_WORKSPACE -name "*.wdl")
do
    if [ $(echo $file | grep -cvf .sprocket.yml) -eq 0 ]; then
        echo "  [***] Excluding $file [***]"
        continue
    fi
    echo "  [***] $file [***]"
    sprocket check $lint $file || EXITCODE=$(($? || EXITCODE))
done

echo "status=$EXITCODE" >> $GITHUB_OUTPUT
exit $EXITCODE
