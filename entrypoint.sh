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
echo "config: $INPUT_CONFIG"
echo "output-dir: $INPUT_OUTPUT_DIR"
echo "overwrite: $INPUT_OVERWRITE"
echo "inputs: $INPUT_INPUTS"
echo
echo "=== Output ==="

# A method to trim any preceding/following spaces.
trim() {
    local input="$1"
    input="${input#"${input%%[![:space:]]*}"}"
    input="${input%"${input##*[![:space:]]}"}"
    echo "$input"
}

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
    args=$(trim $args)

    echo "  [*] Checking WDL files using \`sprocket $INPUT_ACTION\`."
    for source in $INPUT_SOURCES;
    do
        if [ -e ".sprocket.yml" ]
        then
            if [ $(echo $source | grep -cvf .sprocket.yml) -eq 0 ]
            then
                echo "    [-] Excluding $source."
                continue
            fi
        fi

        if [ -f "$source" ]; then
            files=("$source")
        elif [ -d "$source" ]; then
            mapfile -t files < <(find "$source" -type f -name '*.wdl')
        else
            echo "warning: '$source' is neither a file nor a directory; skipping..." >&2
            continue;
        fi

        echo "    [+] Checking \`$source\`."

        for file in $files;
        do
            echo "      - Running \`sprocket check --suppress-imports $args $file\`."
            sprocket check --suppress-imports $args $file
            EXITCODE=$?
        done
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
        sprocket validate "$FILE" "$INPUT"
        EXITCODE=$?
    done

    echo "status=$EXITCODE" >> $GITHUB_OUTPUT
    exit $EXITCODE
elif [ $INPUT_ACTION = "run" ]; then
    echo "  [*] Running a WDL file."

    IFS=' ' read -r -a sources <<< "$INPUT_SOURCES"

    if [ ${#sources[@]} -ne 1 ]; then
        echo "error: only one source may be specified for \`run\` action, found ${#sources[@]}."
        exit 1
    elif [ ! -f "${sources[0]}" ]; then
        echo "error: the specified source must be a file."
        exit 1
    fi

    FILE=${sources[0]}
    args=""

    if [[ -n $INPUT_CONFIG ]]; then
        echo "Adding config: \"$INPUT_CONFIG\""
        args="$args --config $INPUT_CONFIG"
    fi

    if [[ -n $INPUT_OUTPUT_DIR ]]; then
        echo "Adding output directory: \"$INPUT_OUTPUT_DIR\""
        args="$args --output $INPUT_OUTPUT_DIR"
    fi

    if [[ $INPUT_OVERWRITE == true ]]; then
        echo "Adding overwrite: \"$INPUT_OVERWRITE\""
        args="$args --overwrite"
    fi

    args=$(trim "$args $FILE $INPUT_INPUTS")

    echo "      - Running \`sprocket run $args\`"
    sprocket run $args
    EXITCODE=$?

    echo "status=$EXITCODE" >> $GITHUB_OUTPUT
    exit $EXITCODE
else
    echo "Invalid or unsupported action: \`$INPUT_ACTION\`. Exiting."
    exit 1
fi

