# AWS.md

### Installation and setup

#### Account 

Create an AWS account.

#### CLI

Download `aws` command line interface [here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).

#### S3 (file storage)

In the online AWS Management Console:

- create an S3 bucket (`my-bucket-name`)
- under `IAM`, create a user (`my-user`). 
- under `IAM`, create a policy (`my-s3-policy`), replacing `my-bucket-name` with your bucket's name:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "S3UploadPermission",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Resource": "arn:aws:s3:::my-bucket-name/*"
        }
    ]
}
```
- under `IAM`, click on `my-user` and then "security credentials," then "create new access key"

#### CLI -> S3 configuration 

On your local machine: 

- type `aws configure` and use the new access key to fill out the prompts:

```sh
$ aws configure
AWS Access Key ID [None]: DKFJKDSJFKSDJFKDFJKSDFJ
AWS Secret Access Key [None]: SDLKFJKdsfjsdkfSKDFJDKSFksdfjSDFK
Default region name [None]: us-east-1
Default output format [None]: json
```

- create a git hooks pre-push script (`vim .git/hooks/pre-push`) with the below contents:
```sh
#!/bin/sh

# Path to your script
echo "Git pre-push hook: running upload.sh..."
./shmake/aws/upload.sh

```
- make the script executable: `chmod +x .git/hooks/pre-push`


#### Lambda (serverless latex compilation)

In the online AWS Management Console:
- Under `Lambda`, create a new function called `compile_tex` with runtime "Python 3.8", arm64 architecture, 

#### Lambda function permissions

In the online AWS Management Console:

- Under `IAM`, find the execution role for your Lambda function (it will typically be listed under Roles) and attach the `AmazonS3FullAccess` Policy. Note that this will give access to all S3 buckets.

- Under `IAM`, create a policy (`my-lambda-policy`), replacing `function-name` with your lambda function's name:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "LambdaInvokePermission",
            "Effect": "Allow",
            "Action": "lambda:InvokeFunction",
            "Resource": "arn:aws:lambda:region:account-id:function:function-name"
        }
    ]
}
```



