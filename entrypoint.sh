#!/bin/bash

lint=$1

errors=0
ret=0

echo "Checking WDL files using \`sprocket lint\`."
for file in $(find $GITHUB_WORKSPACE -name "*.wdl")
do
    echo "  [***] $file [***]"
    ret=$(sprocket check $lint $file)
    if [ $ret -ne 0 ]
    then
        echo "$file has errors" >> $GITHUB_OUTPUT
        errors=1
    fi
done

if [ $errors -eq 0 ]
then
    echo "No errors found" >> $GITHUB_OUTPUT
    exit 0
else
    exit 1
fi
