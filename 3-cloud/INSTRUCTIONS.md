# The Quote Getter

Every five minutes, this really useful application grabs three random quotes from the 
`quotable.io` API and saves them to an S3 bucket in JSON format.

## Deployment Instructions
Assuming you have forked and cloned this repo...
1. Make sure you are in the `3-cloud` subdirectory.
1. Type `make requirements`
1. `make dev-setup`
1. `make run-checks`
1. If all tests and checks pass (they should), then change to the `terraform` directory.
1. `terraform init`
1. `terraform plan`
1. `terraform apply`. Note: the state is held in a local file.

These steps should all work until `terraform plan`. 

### Part One
Fix all the problems so that the application deploys correctly. (You can assume that the 
Python code is correct and does not need changing.)

### Part Two (Extension)
Add some monitoring and alerting. Occasionally, the application spots a particularly fine quote
and marks it with a log message flagged as `[GREAT QUOTE]`. Make sure your mentor receives
an email whenever this happens.

### Part Three (Really Very Optional)
Create a CI/CD pipeline in Github Actions to deploy this on push.


