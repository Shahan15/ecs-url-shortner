resource "aws_wafv2_web_acl" "alb-waf" {
  name        = "alb-waf"
  description = "WAF for the ALB"
  scope       = "REGIONAL"

  # Allows all by default.
  default_action {
    allow {}
  }

  # Standard AWS Core Managed Rule Set - Prevents SQL Injection. 
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    # Custom Firewall RUle set but we are using a preconfigured rule set by AWS
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    # This block allows us to track what is being caught - One for the specific Rule set and one for entire firewall.
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "url-shortener-waf-metric"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_association" "waf_alb_association" {
  resource_arn = var.alb-arn
  web_acl_arn  = aws_wafv2_web_acl.alb-waf.arn
}
