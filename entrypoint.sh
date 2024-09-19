#!/bin/bash

env

lint=""

if [ $INPUT_LINT = "true" ]; then
    lint="--lint"
fi

warnings=""

if [ ${INPUT_WARNINGS} = "true" ]; then
    warnings="--deny-warnings"
fi

notes=""

if [ ${INPUT_NOTES} = "true" ]; then
    notes="--deny-notes"
fi

exclusions=${INPUT_PATTERNS}
echo "exclusions: $exclusions"

if [ -n "$exclusions" ]; then
    echo "Exclusions provided. Writing to .sprocket.yml."
    echo -n "" > .sprocket.yml
    for exclusion in $(echo $exclusions | sed 's/,/ /')
    do
        echo "$exclusion" >> .sprocket.yml
    done
    cat .sprocket.yml
fi

EXITCODE=0

echo "Checking WDL files using \`sprocket lint\`."
for file in $(find $GITHUB_WORKSPACE -name "*.wdl")
do
    if [ -e ".sprocket.yml" ]
    then
        if [ $(echo $file | grep -cvf .sprocket.yml) -eq 0 ]
        then
            echo "  [***] Excluding $file [***]"
            continue
        fi
    fi
    echo "  [***] $file [***]"
    sprocket check $lint $warnings $notes $file || EXITCODE=$(($? || EXITCODE))
done

echo "status=$EXITCODE" >> $GITHUB_OUTPUT
exit $EXITCODE
