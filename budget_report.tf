resource "aws_budgets_budget" "report" {
  name              = "budget-28cld-daily"
  budget_type       = "COST"
  limit_amount      = "5"
  limit_unit        = "USD"
  time_unit         = "DAILY"

  cost_filter {
    name = "Region"
    values = [
      var.region
    ]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = var.mail_notification
  }
}