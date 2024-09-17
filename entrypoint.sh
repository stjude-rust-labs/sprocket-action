#!/bin/bash

lint=""
warnings=""
notes=""

while [ "$#" -gt 0 ]; do
    arg=$1
    case $1 in
        -l|--lint) lint="--lint"; shift;;
        -w|--deny-warnings) warnings="--deny-warnings"; shift;;
        -n|--deny-notes) notes="--deny-notes"; shift;;
        ''|"") shift;;
        *) break;;
    esac
done

exclusions=$1

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
    sprocket check $lint $warnings $notes $file || EXITCODE=$(($? || EXITCODE))
done

echo "status=$EXITCODE" >> $GITHUB_OUTPUT
exit $EXITCODE
