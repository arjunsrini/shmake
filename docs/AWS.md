# AWS.md

### Installation and setup

Create an AWS account.

Download `aws` command line interface [here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).

In your online account:

- Create an S3 bucket (`my-bucket-name`).
- Under `IAM`, create a user (`my-user`). 
- Under `IAM`, create a policy (`my-s3-policy`), replacing `my-bucket-name` with your bucket's name:

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
- Under `IAM`, click on `my-user` and then "security credentials," then "create new access key."
- On your local machine, type `aws configure` and use the new access key to fill out the prompts:

```sh
$ aws configure
AWS Access Key ID [None]: DKFJKDSJFKSDJFKDFJKSDFJ
AWS Secret Access Key [None]: SDLKFJKdsfjsdkfSKDFJDKSFksdfjSDFK
Default region name [None]: us-east-1
Default output format [None]: json
```


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



