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
Fix all the problems so that the application deploys correctly. 

#### Key Issues:
- The code should be triggered by an Eventbridge Scheduler (implemented in Terraform as a CloudWatch
Event Scheduler). This has not been implemented. (See `events.tf`)
- You may find that the Lambda deploys correctly and can be invoked, but that it does not run. You 
should assume that the Python code is correctly written and should not be changed. There are other issues
with the deployment code.

### Part Two (Extension)

Add some monitoring and alerting. Occasionally, the application spots a particularly fine quote
and marks it with a log message flagged as `[GREAT QUOTE]`. Make sure your mentor receives
an email whenever this happens.

### Part Three (Really Very Optional)

Create a CI/CD pipeline in Github Actions to deploy this on push.

