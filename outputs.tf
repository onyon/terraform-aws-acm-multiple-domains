output "record" {
  value       = aws_route53_record.tls-entry
  sensitive   = false
  description = "DNS entry for certificate manager authentication."
}