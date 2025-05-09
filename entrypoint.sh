#!/bin/bash

set -euo pipefail

echo "=== Configuration ==="
echo "action: $INPUT_ACTION"
echo "sources: $INPUT_SOURCES"
echo "lint: $INPUT_LINT"
echo "exceptions: $INPUT_EXCEPT"
echo "warnings: $INPUT_WARNINGS"
echo "notes: $INPUT_NOTES"
echo "patterns: $INPUT_PATTERNS"
echo "inputs_files: $INPUT_INPUTS_FILES"
echo
echo "=== Output ==="

if [ $INPUT_ACTION = "check" ] || [ $INPUT_ACTION = "lint" ]; then
    echo "  [*] Checking and/or linting WDL files."
    args=""

    if [ $INPUT_LINT = "true" ] || [ $INPUT_ACTION = "lint" ]; then
        args="$args --lint"
    fi

    if [ -n "$INPUT_EXCEPT" ]; then
        echo "  [*] Excepted rule(s) provided."
        for exception in $(echo $INPUT_EXCEPT | sed 's/,/ /')
        do
            args="$args --except $exception"
            echo "    [-] $exception"
        done
    fi

    if [ ${INPUT_WARNINGS} = "true" ]; then
        args="$args --deny-warnings"
    fi

    if [ ${INPUT_NOTES} = "true" ]; then
        args="$args --deny-notes"
    fi

    exclusions=${INPUT_PATTERNS}

    if [ -n "$exclusions" ]; then
        echo "  [*] Exclusions provided. Writing to \`.sprocket.yml.\`"
        touch .sprocket.yml
        for exclusion in $(echo $exclusions | sed 's/,/ /g')
        do
            echo "$exclusion" >> .sprocket.yml
            echo "    [-] $exclusion"
        done
    fi

    EXITCODE=0

    echo "  [*] Checking WDL files using \`sprocket $INPUT_ACTION\`."
    for file in $(find $GITHUB_WORKSPACE -name "*.wdl")
    do
        if [ -e ".sprocket.yml" ]
        then
            if [ $(echo $file | grep -cvf .sprocket.yml) -eq 0 ]
            then
                echo "    [-] Excluding $file."
                continue
            fi
        fi
        echo "    [+] Checking $file."
        echo "      - Running \`sprocket check --suppress-imports $args $file\`."
        sprocket check --suppress-imports $args $file || EXITCODE=$(($? || EXITCODE))
    done

    echo "status=$EXITCODE" >> $GITHUB_OUTPUT
    exit $EXITCODE
elif [ $INPUT_ACTION = "validate" ]; then
    echo "  [*] Validating WDL inputs."

    EXITCODE=0

    # Note: this depends on the user to get the pairing correct upfront.
    for index in "${!INPUT_INPUTS_FILES[@]}"
    do
        FILE=${INPUT_SOURCES[index]};
        INPUT=${INPUT_INPUTS_FILES[index]};
        echo "    [+] Validating \`$FILE\` with \`$INPUT\` as the input".
        echo "      - Running \`sprocket validate $FILE $INPUT\`"
        sprocket validate "$FILE" "$INPUT" || EXITCODE=$(($? || EXITCODE))
    done

    echo "status=$EXITCODE" >> $GITHUB_OUTPUT
    exit $EXITCODE
elif [ $INPUT_ACTION = "run" ]; then
    echo "Action `run` is currently unsupported."
    exit 1
else
    echo "Invalid or unsupported action: \`$INPUT_ACTION\`. Exiting."
    exit 1
fi

