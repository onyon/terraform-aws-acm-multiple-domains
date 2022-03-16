# Terraform Create AWS ACM Certificate For Multiple Domains

The [Terraform documentation for `acm_certificate_validation`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) 
only supports a single domain in the request. This module allows you to support multiple
domains in the request as long as they are the APEX or *.APEX domain. This will
reduce code complexity and cost by allowing you to have a single certificate
with more domains.

```
resource "aws_acm_certificate" "certificate" {
  domain_name       = "mydomain.dev"
  validation_method = "DNS"
  subject_alternative_names = [
    "*.mydomain.dev",
    "myseconddomain.co",
    "*.myseconddomain.co",
    "*.mythirddomain.co.uk"
  ]
}

module "acm-multiple-domains" {
  for_each = {for domain in aws_acm_certificate.certificate.domain_validation_options: domain.domain_name => domain}
  
  source  = "cebollia/acm-multiple-domains/aws"
  version = "1.0.0"

  certificate_arn = aws_acm_certificate.certificate.arn
  domain          = each.key
  name            = each.value.resource_record_name
  type            = each.value.resource_record_type
  record          = each.value.resource_record_value
  ttl             = 3600
}

resource "aws_acm_certificate_validation" "validate" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for domain in module.acm-r53-records : domain.record.fqdn ]
}
```