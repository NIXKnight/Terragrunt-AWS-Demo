variable "parent_domain_name" {
  type = string
}

data "aws_route53_zone" "parent" {
  name         = var.parent_domain_name
  private_zone = false
}

output "zone_id" {
  value = data.aws_route53_zone.parent.zone_id
}

output "zone_name" {
  value = data.aws_route53_zone.parent.name
}
