output "site_url" {
  value = "http://${aws_lb.application_alb.dns_name}"
}