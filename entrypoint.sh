#!/bin/bash

set -euo pipefail

echo "===configuration==="
echo "action: $INPUT_ACTION"
echo "skip_config_search: $INPUT_SKIP_CONFIG_SEARCH"
echo "config_path: $INPUT_CONFIG"
echo "lint: $INPUT_LINT"
echo "exceptions: $INPUT_EXCEPT"
echo "warnings: $INPUT_WARNINGS"
echo "notes: $INPUT_NOTES"
echo "patterns: $INPUT_PATTERNS"
echo "wdl_files: $INPUT_WDL_FILES"
echo "inputs_files: $INPUT_INPUTS_FILES"

skip_config=""
if [ $INPUT_SKIP_CONFIG_SEARCH = "true" ]; then
    skip_config="-s"
fi
config_path=""
if [ -n "$INPUT_CONFIG" ]; then
    config_path="-c $INPUT_CONFIG"
fi
config_args="$skip_config $config_path"

if [ $INPUT_ACTION = "check" ] || [ $INPUT_ACTION = "lint" ]; then
    echo "Checking WDL files."
    lint=""
    if [ $INPUT_LINT = "true" ] || [ $INPUT_ACTION = "lint" ]; then
        lint="--lint"
    fi

    exceptions=""
    if [ -n "$INPUT_EXCEPT" ]; then
        echo "Excepted rule(s) provided."
        for exception in $(echo $INPUT_EXCEPT | sed 's/,/ /g')
        do
            exceptions="$exceptions -e $exception"
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
        echo "Exclusions provided. Appending to .sprocketignore"
        for exclusion in $(echo $exclusions | sed 's/,/ /g')
        do
            echo "$exclusion" >> .sprocketignore
        done
        
        echo "  [***] Ignore File [***]"
        cat .sprocketignore
    fi

    EXITCODE=0

    echo "Checking WDL files using \`sprocket check\`."
    set +x
    sprocket -v $config_args check $lint $warnings $notes $exceptions || EXITCODE=$(($? || EXITCODE))
    set -x

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
        set +x
        sprocket -v $config_args validate "${wdl_files[index]}" "${input_files[index]}" || EXITCODE=$(($? || EXITCODE))
        set -x
    done

    echo "status=$EXITCODE" >> $GITHUB_OUTPUT
    exit $EXITCODE
elif [ $INPUT_ACTION = "run" ]; then
    echo "Action \`run\` is unsupported."
    exit 1
elif [ $INPUT_ACTION = "format" ]; then
    echo "Action \`format\` is currently unsupported."
    exit 1
elif [ $INPUT_ACTION = "analyzer" ]; then
    echo "Action \`analyzer\` is unsupported."
    exit 1
elif [ $INPUT_ACTION = "explain" ]; then
    echo "Action \`explain\` is unsupported."
    exit 1
elif [ $INPUT_ACTION = "completions" ]; then
    echo "Action \`completions\` is unsupported."
    exit 1
elif [ $INPUT_ACTION = "config" ]; then
    echo "Action \`config\` is unsupported."
    exit 1
elif [ $INPUT_ACTION = "dev" ]; then
    echo "Action \`dev\` is unsupported."
    exit 1
elif [ $INPUT_ACTION = "inputs" ]; then
    echo "Action \`inputs\` is unsupported."
    exit 1
else
    echo "Invalid action. Exiting."
    exit 1
fi

