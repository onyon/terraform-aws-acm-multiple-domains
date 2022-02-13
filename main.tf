data "aws_route53_zone" "domain" {
  name         = local.domain
  private_zone = false
}

resource "aws_route53_record" "tls-entry" {
  allow_overwrite = true
  name            = local.name
  records         = [local.record]
  ttl             = local.ttl
  type            = local.type
  zone_id         = data.aws_route53_zone.domain.zone_id
}