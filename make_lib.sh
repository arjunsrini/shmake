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
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);  # Only variable assignments are printed
      }
   }'
}

# eval $(parse_yaml ${PATH_TO_ROOT}/config.yaml)
# echo "export stataCmd=${stataCmd}" >> ${output_file}
# echo "export pathToRepo=${pathToRepo}" >> ${output_file}
# echo "export pathToDb=${pathToDb}" >> ${output_file}

echo "" >> ${output_file}
echo "" >> ${output_file}
