resource "aws_iam_role" "lambda_role" {
    name_prefix = "role-${var.lambda_name}"
    assume_role_policy = data.aws_iam_policy_document.trust_policy.json
}

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


data "aws_iam_policy_document" "s3_data" {
  statement {

    actions = ["s3:PutObject"]

    resources = [
      "${aws_s3_bucket.data_bucket.arn}/*",
    ]
  }
}

data "aws_iam_policy_document" "cw_document" {
  statement {

    actions = [ "logs:CreateLogGroup" ]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
    ]
  }

  statement {

    actions = [ "logs:CreateLogStream", "logs:PutLogEvents" ]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.lambda_name}:*"
    ]
  }
}



resource "aws_iam_policy" "s3_write_policy" {
    name_prefix = "s3-policy-${var.lambda_name}-write"
    policy = data.aws_iam_policy_document.s3_data.json
}


resource "aws_iam_policy" "cw_policy" {
    name_prefix = "cw-policy-${var.lambda_name}"
    policy = data.aws_iam_policy_document.cw_document.json
}


resource "aws_iam_role_policy_attachment" "lambda_s3_write_policy_attachment" {
    role = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.s3_write_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_cw_policy_attachment" {
    role = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.cw_policy.arn
}