#!/bin/bash

set -euo pipefail

echo "===configuration==="
echo "action: $INPUT_ACTION"
echo "lint: $INPUT_LINT"
echo "exceptions: $INPUT_EXCEPT"
echo "warnings: $INPUT_WARNINGS"
echo "notes: $INPUT_NOTES"
echo "patterns: $INPUT_PATTERNS"
echo "wdl_files: $INPUT_WDL_FILES"
echo "inputs_files: $INPUT_INPUTS_FILES"

if [ $INPUT_ACTION = "check" ] || [ $INPUT_ACTION = "lint" ]; then
    echo "Checking WDL files."
    lint=""
    exceptions=""
    if [ $INPUT_LINT = "true" ] || [ $INPUT_ACTION = "lint" ]; then
        lint="--lint"
    fi

    if [ -n "$INPUT_EXCEPT" ]; then
        echo "Excepted rule(s) provided."
        for exception in $(echo $INPUT_EXCEPT | sed 's/,/ /')
        do
            exceptions="$exceptions --except $exception"
        done
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
        for exclusion in $(echo $exclusions | sed 's/,/ /g')
        do
            echo "$exclusion" >> .sprocket.yml
        done
        
        echo "  [***] Exclusions [***]"
        cat .sprocket.yml
    fi

    EXITCODE=0

    echo "Checking WDL files using \`sprocket check\`."
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
        echo "sprocket check --suppress-imports $lint $warnings $notes $exceptions $file"
        sprocket check --suprpress-imports $lint $warnings $notes $exceptions $file || EXITCODE=$(($? || EXITCODE))
    done

    echo "status=$EXITCODE" >> $GITHUB_OUTPUT
    exit $EXITCODE
elif [ $INPUT_ACTION = "validate" ]; then
    echo "Validating inputs"

    EXITCODE=0

    # Split the input variables on "," to get the list of files.
    # IFS treats each character as a delimiter.
    IFS=',' read -r -a wdl_files <<< "$INPUT_WDL_FILES"
    IFS=',' read -r -a input_files <<< "$INPUT_INPUTS_FILES"

    # Note: this depends on the user to get the pairing correct upfront.
    for index in "${!input_files[@]}"
    do
        echo "sprocket validate ${wdl_files[index]} ${input_files[index]}"
        sprocket validate "${wdl_files[index]}" "${input_files[index]}" || EXITCODE=$(($? || EXITCODE))
    done

    echo "status=$EXITCODE" >> $GITHUB_OUTPUT
    exit $EXITCODE
elif [ $INPUT_ACTION = "run" ]; then
    echo "Action `run` is currently unsupported."
    exit 1
elif [ $INPUT_ACTION = "format" ]; then
    echo "Action `format` is currently unsupported."
    exit 1
elif [ $INPUT_ACTION = "analyzer" ]; then
    echo "Action `analyzer` is unsupported."
    exit 1
elif [ $INPUT_ACTION = "explain" ]; then
    echo "Action `explain` is unsupported."
    exit 1
else
    echo "Invalid action. Exiting."
    exit 1
fi

