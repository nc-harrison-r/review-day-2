# The Quote Getter

This lambda function should run on a schedule; every five minutes. When it runs it will grab three random quotes from the `quotable.io` API and saves them to an S3 bucket in JSON format.

## Deployment Instructions

Assuming you have forked and cloned this repo...

1. Make sure you are in the `3-cloud` subdirectory.
2. Type `make requirements`
3. `make dev-setup`
4. `make run-checks`
5. If all tests and checks pass (they should), then change to the `terraform` directory.
6. `terraform init` Note: the state is held in a local file.

### Part One

The above steps should all work until `terraform plan`.

Complete any sections of Terraform files where you can see a `TODO`.

Un-comment terraform code blocks as you begin working on them by moving the opening multi-line-comment mark - `/*`

Use `terraform plan` to debug that the application deploys correctly.

### Part Two (Extension)

Add some monitoring and alerting. Occasionally, the application spots a particularly fine quote
and marks it with a log message flagged as `[GREAT QUOTE]`. Make sure your mentor receives
an email whenever this happens.

### Part Three (Really Very Optional)

Create a CI/CD pipeline in Github Actions to deploy this on push.
