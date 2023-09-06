#!/bin/bash   

# separates "./path/to/program.do" into
#   (1) file = program.do
#   (2) extension = do
#   (3) path_to_file = ./path/to/
#   (4) filename = program
unset parse_fp 
parse_fp () {

    # get arguments
    fp="$1"
    opt="$2"
    
    file="${fp##*/}"

    case $opt in
        1)  output="${file}"
            ;;
        2)  output="${file##*.}"
            ;;
        3)  output="${fp%"${file}"}"
            ;;
        4)  output="${file%.*}"
            ;;
        *)  output="ERROR in parse_fp: unmatched option"
            ;;
    esac

    echo "${output}"

}

unset run_stata
run_stata () {

    if [[ $# -eq 3 ]]
    then 
        # get arguments
        stata_cmd="$1"
        program="$2"
        logfile="$3"

        # get path to file and file name
        local path_to_file=$(parse_fp "${program}" 3)
        local filename=$(parse_fp "${program}" 4)

        # run program
        (${stata_cmd} -e do code/${program})

        # add default log to log file
        cat "${filename}.log" >> "${logfile}"
        # delete default log
        rm "${filename}.log"

    elif [[ $# -eq 2 ]]
    then
        # get arguments
        stata_cmd="$1"
        program="$2"

        # run stata (log file handled elsewhere)
        (${stata_cmd} -e do ${program})

    else 
        echo "ERROR IN RUN STATA: INVALID NUMBER OF ARGS"
    fi

}

unset run_shell
run_shell () {

    # get arguments
    program="$1"
    logfile="$2"

    # run program, add output to logfile
    (${SHELL} code/${program} >> "${logfile}")

}

# relies on globals:
#   stataCmd
#   LOGFILE
unset run_programs_in_order
run_programs_in_order () {

    # read a line
    while read prog; do
        # ensure its not just whitespace: 
        # https://unix.stackexchange.com/questions/146942/how-can-i-test-if-a-variable-is-empty-or-contains-only-spaces
        # and doesn't start with #
        # https://www.cyberciti.biz/faq/bash-check-if-string-starts-with-character-such-as/
        if ! [[ -z "${prog// }" || $prog = \#* ]];
        then 
            # parse program for extension
            local extension=$(parse_fp "${prog}" 2)
            case "${extension}" in
                "do")   echo "Running: ${prog}"
                        run_stata "${stataCmd}" "${prog}" "${LOGFILE}"
                        ;;
                "sh")   echo "Running: ${prog}"
                        run_shell "${prog}" "${LOGFILE}"
                        ;;
                *)      echo "SKIPPED: ${prog}"
                        echo "No executable for files of type: ${extension}"
                        ;;
            esac 
        fi
    done
}

