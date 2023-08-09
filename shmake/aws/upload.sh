#!/bin/bash

# Get the root directory of the repository
repo_root=$(git rev-parse --show-toplevel)

# Get the current commit hash
commit_hash=$(git rev-parse HEAD)

# Get the directory of the script, assuming it's located in ./shmake/aws/
script_dir="${repo_root}/shmake/aws"
file_path="${script_dir}/aws_s3.txt"

# Initialize variables
current_bucket=""

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
    directory_path="${line#  dir:}"

    # Resolve the path relative to the repo root
    absolute_directory_path="${repo_root}/${directory_path}"

    # Check if the path is a directory
    if [ -d "$absolute_directory_path" ]; then
      # Use the basename of the directory as part of the filename
      directory_name=$(basename $directory_path)

      # Create a tar archive with the commit hash and directory name
      tar -cvzf "${script_dir}/${commit_hash}_${directory_name}.tar.gz" -C "$directory_path" .

      # Upload the archive to S3
      aws s3 cp "${script_dir}/${commit_hash}_${directory_name}.tar.gz" "s3://${current_bucket}/${commit_hash}_${directory_name}.tar.gz"
    else
      echo "Skipping $absolute_directory_path as it is not a directory."
    fi
  fi
done < "$file_path"
