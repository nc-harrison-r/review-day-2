# ---------------
# Lambda IAM Role
# ---------------

# Define
data "aws_iam_policy_document" "trust_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
#This block defines a general trust policy that, when applied to an IAM role, allows any Lambda function to assume that role.

# Create
resource "aws_iam_role" "lambda_role" {
  name_prefix        = "role-${var.lambda_name}"
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json
}
# Creates the IAM role using the trust policy above. This role allows the lambda function to assume the role and use the permissions defined in the policies attached to it.
#AKA the lambda can now run on AWS.


# ------------------------------
# Lambda IAM Policy for S3 Write
# ------------------------------

# Define



data "aws_iam_policy_document" "s3_data_policy_doc" {
  statement {
    #TODO: this statement should give permission to put objects in the data bucket
    actions = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.data_bucket.arn}/*"]
    effect = "Allow"
  }
}
# Allows lambda to put objects in the S3 bucket referenced.  

# Create
resource "aws_iam_policy" "s3_write_policy" {
  name_prefix = "s3-policy-${var.lambda_name}-write"
  policy      = data.aws_iam_policy_document.s3_data_policy_doc.json #TODO use the policy document defined above
}
# Creates the actual IAM policy document for S3 access.

# Attach
resource "aws_iam_role_policy_attachment" "lambda_s3_write_policy_attachment" {
    #TODO: attach the s3 write policy to the lambda role
    role = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.s3_write_policy.arn
}
#Attaches the policy to rhe lambdas IAM role.

# IN SHORT
#Define what the permission is

#Turn that into an actual policy object

#Attach that policy to the Lambda's IAM role

# ------------------------------
# Lambda IAM Policy for CloudWatch
# ------------------------------

# Define
data "aws_iam_policy_document" "cw_document" {
  statement {
    #TODO: this statement should give permission to create Log Groups in your account
    effect = "Allow"
    actions = ["logs:CreateLogGroup"]
    # resources = ["*"]
    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
  }

  statement {
    #TODO: this statement should give permission to create Log Streams and put Log Events in the lambda's own Log Group
    effect = "Allow"
    actions = ["logs:CreateLogStream", "logs:PutLogEvents"]
    # resources = ["*"]
    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.lambda_name}:*"]
  }
}
# # Defines a policy document that allows the Lambda to create log groups, log streams, and write log events to CloudWatch Logs. And where to put the logs.

# Create
resource "aws_iam_policy" "cw_policy" {
  #TODO: use the policy document defined above
  name = "lambda_logging"
  policy = data.aws_iam_policy_document.cw_document.json
}
#Creates an actual IAM policy from the above document, which can be attached to roles.

# Attach
resource "aws_iam_role_policy_attachment" "lambda_cw_policy_attachment" {
  #TODO: attach the cw policy to the lambda role
  role = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.cw_policy.arn
}
# Attaches the logging policy to the Lambda’s IAM role (role=) so it has permission to send logs to CloudWatch.

#EVENT RULE
# # Give IAM permission for cloudwatch events to invoke the lambda function
# resource "aws_lambda_permission" "allow_cloudwatch" {
#   statement_id = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.quote_handler.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.scheduler.arn
# }