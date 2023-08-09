# Configure the AWS Provider
provider "aws" {
  region = "us-west-1" # You can change this to your preferred region
}

# Create an S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "shmake" # Change this to your desired bucket name
  acl    = "private"
}

# Create a Lambda function
resource "aws_lambda_function" "my_lambda" {
  function_name = "compile_tex"
  handler       = "lambda_function.lambda_handler" # Update this based on your Lambda function's handler
  runtime       = "python3.8"

  role          = aws_iam_role.lambda_exec_role.arn

  # If you have your lambda code in a zip file
  filename      = "path/to/your/lambda.zip"
}

# IAM role for Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ],
    Version = "2012-10-17"
  })
}

# IAM policy to allow Lambda access to S3
resource "aws_iam_role_policy" "lambda_s3_policy" {
  name = "lambda_s3_policy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Statement = [
      {
        Action   = ["s3:GetObject", "s3:PutObject"],
        Effect   = "Allow",
        Resource = ["arn:aws:s3:::my-bucket-name/*"]
      }
    ],
    Version = "2012-10-17"
  })
}
