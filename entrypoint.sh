#!/bin/bash

echo "===configuration==="
echo "lint: $INPUT_LINT"
echo "exceptions: $INPUT_EXCEPT"
echo "warnings: $INPUT_WARNINGS"
echo "notes: $INPUT_NOTES"
echo "patterns: $INPUT_PATTERNS"

lint=""
exceptions=""

if [ $INPUT_LINT = "true" ]; then
    lint="--lint"
    if [ -n "$INPUT_EXCEPT" ]; then
        echo "Excepted rule(s) provided."
        for exception in $(echo $INPUT_EXCEPT | sed 's/,/ /')
        do
            exceptions="$exceptions --except $exception"
        done
    fi
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

if [ -n "$exclusions" ]; then
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
    if [ -e ".sprocket.yml" ]
    then
        if [ $(echo $file | grep -cvf .sprocket.yml) -eq 0 ]
        then
            echo "  [***] Excluding $file [***]"
            continue
        fi
    fi
    echo "  [***] $file [***]"
    echo "sprocket check $lint $warnings $notes $exceptions $file"
    sprocket check $lint $warnings $notes $exceptions $file || EXITCODE=$(($? || EXITCODE))
done

echo "status=$EXITCODE" >> $GITHUB_OUTPUT
exit $EXITCODE
