resource "aws_wafv2_web_acl" "waf-magri" {
  name  = "WAF-MAGRI-ACL"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesAdminProtectionRuleSet"
    priority = 0

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAdminProtectionRuleSet"
        vendor_name = "AWS"

        excluded_rule {
          name = "AdminProtection_URIPATH"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAdminProtectionRuleSet"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "WAF-MAGRI-ACL"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "web_acl_association_magri_elb" {
  resource_arn = aws_lb.magri-alb.arn
  web_acl_arn  = aws_wafv2_web_acl.waf-magri.arn
}