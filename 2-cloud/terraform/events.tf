# resource "aws_cloudwatch_event_rule" "scheduler" {
#   #TODO: this should set up a scheduler that will trigger the Lambda every 5 minutes
#   # Careful! other things may need to be set up as well
#   name = "5-min-trigger"
#   description = "Trigger the Lambda function every 5 minutes"
#   schedule_expression = "rate(5 minutes)"
# }

# # Link the event rule to the lambda function:
# resource "aws_cloudwatch_event_target" "target_quote_handler" {
#   target_id = "target_quote_handler"
#   rule = aws_cloudwatch_event_rule.scheduler.name
#   arn = aws_lambda_function.quote_handler.arn
# }