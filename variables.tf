variable "certificate_arn" {}
variable "domain" {}
variable "name" {}
variable "type" {}
variable "record" {}
variable "ttl" {}

locals {
  certificate_arn = var.certificate_arn
  domain          = replace(var.domain,"*.","")
  name            = var.name
  type            = var.type
  record          = var.record
  ttl             = var.ttl
}