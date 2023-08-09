import boto3
import subprocess
import os
import tempfile
from urllib.parse import unquote_plus

s3_client = boto3.client('s3')

def compile_tex(event, context):
    # Extract the S3 bucket and key from the "dir" parameter
    s3_bucket, s3_key = event['dir'][5:].split('/', 1)
    main_file_path = event['main']

    # Create temporary directories for unzipping and compiling
    unzip_dir = tempfile.mkdtemp()
    compile_dir = tempfile.mkdtemp()

    # Download the tar archive from S3
    tar_path = os.path.join(unzip_dir, 'archive.tar.gz')
    s3_client.download_file(s3_bucket, s3_key, tar_path)

    # Unzip the tar archive
    subprocess.run(['tar', 'xzf', tar_path, '-C', unzip_dir])

    # Copy main .tex file to compile directory
    main_file_name = os.path.basename(main_file_path)
    compile_main_path = os.path.join(compile_dir, main_file_name)
    os.rename(os.path.join(unzip_dir, main_file_name), compile_main_path)

    # Compile the .tex file into a PDF
    compile_result = subprocess.run(['pdflatex', '-output-directory', compile_dir, compile_main_path], capture_output=True)

    # Extract the commit_hash, directory_name, and main_file (without .tex) for the output filename
    commit_hash, directory_name, main_file = os.path.basename(s3_key).split('_', 2)
    main_file = main_file[:-4]  # Removing the .tar.gz extension
    output_prefix = f"{commit_hash}_{directory_name}_{main_file}"

    # If compilation is successful, upload PDF; otherwise, upload log file
    if compile_result.returncode == 0:
        pdf_path = os.path.join(compile_dir, main_file + '.pdf')
        output_key = f"{output_prefix}.pdf"
        s3_client.upload_file(pdf_path, s3_bucket, output_key)
    else:
        log_path = os.path.join(compile_dir, main_file + '.log')
        with open(log_path, 'w') as log_file:
            log_file.write(compile_result.stderr.decode('utf-8'))
        output_key = f"{output_prefix}.log"
        s3_client.upload_file(log_path, s3_bucket, output_key)

    return {
        'statusCode': 200,
        'body': 'Compilation completed'
    }

