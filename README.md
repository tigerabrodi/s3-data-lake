# S3 Data Lake Project

This is a bit different compared to the back up solution I built.

Here the S3's purpose is to store the data in a raw format. It serves as a data lake.

# Variables

You need to set the following variables in the `terraform.tfvars.json` file:

```json
{
  "arn_of_s3_bucket_owner": "{here goes the ARN of the account that owns the S3 bucket}"
}
```
