#!/bin/bash   
# 
# Creates links to external directories
#   in external subdirectory
#   based on "external.txt" in root.
# 

# relies on globals:
unset link_externals
link_externals () {

    # read a line
    while read extdir; do
        # ensure its not just whitespace: 
        # https://unix.stackexchange.com/questions/146942/how-can-i-test-if-a-variable-is-empty-or-contains-only-spaces
        # and doesn't start with #
        # https://www.cyberciti.biz/faq/bash-check-if-string-starts-with-character-such-as/
        if ! [[ -z "${extdir// }" || $extdir = \#* ]];
        then 

            # Set | as delimiter
            IFS='|'
            # Read the split words into an array based on  delimiter
            read -a array <<< "$extdir"

            #Print the splitted words
            dir_new_tmp=${array[0]}
            dir_new=${dir_new_tmp%?}
            macro=$(echo ${array[1]} | xargs)
            dir_existing=${!macro}
            (cd external; ln -fsn ${dir_existing} ${dir_new})

        fi
    done
}

mkdir -p external
cat ${PATH_TO_ROOT}/external.txt | link_externals
