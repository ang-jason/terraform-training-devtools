resource "aws_budgets_budget" "cost_budget" {
  name         = "default-budget-alert"
  budget_type  = "COST"
  limit_amount = "10"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "EQUAL_TO"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = ["drngusi9x@gmail.com"]
  }
}
