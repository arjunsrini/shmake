#!/bin/bash

# Get the root directory of the repository
repo_root=$(git rev-parse --show-toplevel)

# Get the current commit hash
commit_hash=$(git rev-parse HEAD)

# Get the directory of the script, assuming it's located in ./shmake/aws/
script_dir="${repo_root}/shmake/aws"
file_path="${script_dir}/to_compile.txt"

# Initialize variables
current_bucket=""
directory_path=""
main_file=""

# Read the file line by line
while IFS= read -r line
do
  # Skip empty lines and lines starting with '#'
  if [[ -z "$line" || "$line" == \#* ]]; then
    continue
  fi

  # Check if the line starts with "bucket:"
  if [[ "$line" == "bucket:"* ]]; then

    # Extract the bucket name
    current_bucket="${line#bucket: }"
    continue
  fi

  # Check if the line starts with "dir:"
  if [[ "$line" == "  dir:"* ]]; then

    # Extract the directory path
    # (xargs used to trim leading/trailing spaces)
    directory_path="$(echo "${line#  dir:}" | xargs)"

    # Resolve the path relative to the repo root
    # absolute_directory_path="${repo_root}/${directory_path}"
    continue
  fi

  # Check if the line starts with "dir:"
  if [[ "$line" == "  file:"* ]]; then

    # Extract the file path
    # (xargs used to trim leading/trailing spaces)
    texfile="$(echo "${line#  file:}" | xargs)"

  fi

  # Check if both the directory path and main file have been set
  if [ -d "$directory_path" ] && [ -f "${directory_path}/${texfile}" ]; then

    # Go to relevant directory
    cd "${directory_path}"

    # Compile the pdf
    pdflatex -interaction=nonstopmode -output-directory="${script_dir}/compiled" "${texfile}"

    # Wait a second
    sleep 2

    # Re-compile the pdf
    pdflatex -interaction=nonstopmode -output-directory="${script_dir}/compiled" "${texfile}"

    # Upload the archive to S3
    echo "Would upload to S3 here"
    # aws s3 cp "${script_dir}/${commit_hash}_${directory_name}.tar.gz" "s3://${current_bucket}/${commit_hash}_${directory_name}.tar.gz"

  else

    echo "Skipping $file_path as it is not a directory or main file is missing."

  fi
done < "$file_path"

