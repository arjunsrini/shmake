#!/bin/bash   
# 
# Make 1 temporary lib file 'lib.sh'
#   with all shell functions and 
#   user defined config variables.
# 

# Make lib.sh

# source dir
dir_source=$( dirname -- "$0")
dir_functions="$dir_source/functions"
output_file="$dir_source/lib.sh"

# appends together all other shell programs in directory
rm -f ${output_file}
for f in $(find ${dir_functions} -name '*.sh')
do
    cat $f >> ${output_file}
    echo "" >> ${output_file}
    echo "" >> ${output_file}
done

# handle config yaml
unset parse_yaml
function parse_yaml() {
   # Read the file and extract values
   while IFS=: read -r key value
   do
      # Trim leading and trailing spaces
      key=$(echo $key | xargs)
      value=$(echo $value | xargs)

      # Assign the values to variables
      case $key in
         pathToRepo)
               pathToRepo="$value"
               ;;
         pathToDb)
               pathToDb="$value"
               ;;
         stataCmd)
               stataCmd="$value"
               ;;
         pythonCmd)
               pythonCmd="$value"
               ;;
      esac
   done < "$1"

   echo "export stataCmd=${stataCmd}" >> ${output_file}
   echo "export pathToRepo=${pathToRepo}" >> ${output_file}
   echo "export pathToDb=${pathToDb}" >> ${output_file}
   echo "export pythonCmd=${pythonCmd}" >> ${output_file}

}

if [ -f "${PATH_TO_ROOT}/config.yaml" ]; then
   eval $(parse_yaml ${PATH_TO_ROOT}/config.yaml)
else
   echo "No config.yaml file found in root directory."
fi

echo "" >> ${output_file}
echo "" >> ${output_file}
