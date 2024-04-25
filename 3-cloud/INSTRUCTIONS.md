# The Quote Getter

This lambda function should run on a schedule; every five minutes. When it runs it will grab three random quotes from the `quotable.io` API and saves them to an S3 bucket in JSON format.

## Deployment Instructions

Assuming you have forked and cloned this repo...

1. Make sure you are in the `3-cloud` subdirectory.
2. Type `make requirements`
3. `make dev-setup`
4. `make run-checks`
5. If all tests and checks pass (they should), then change to the `terraform` directory.
6. `terraform init`
7. `terraform plan`
8. `terraform apply`. Note: the state is held in a local file.

These steps should all work until `terraform plan` - take note of the error it shows you, this will come into play for the first task.

### Part One

Complete the terraform so that the application deploys correctly. (You can assume that the
Python code is correct and does not need changing.)

Things you will need to do:

1. There is a `aws_cloudwatch_event_rule` block in the `events.tf` file. Have a look at how you can use this resource to set up the 5 minute schedule.
2. There are already a few IAM permissions set up, however there may be more that are necessary. You can use run test events on the AWS console to check if the code is working.
3. The lambda code makes use of a environment variable `S3_BUCKET_NAME`, do a bit of research to find out how to set environment variables for lambda functions with terraform.

Once you have **finished part one**, please submit your code for review using the `/nchelp review` slack command.

### Part Two (Extension)

Add some monitoring and alerting. Occasionally, the application spots a particularly fine quote
and marks it with a log message flagged as `[GREAT QUOTE]`. Make sure your mentor receives
an email whenever this happens.

### Part Three (Really Very Optional)

Create a CI/CD pipeline in Github Actions to deploy this on push.
