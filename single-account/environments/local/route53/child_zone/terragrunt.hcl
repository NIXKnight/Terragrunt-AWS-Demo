include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "route53_zones" {
  path   = find_in_parent_folders("_common/route53_zone.hcl")
  expose = true
}

locals {
  module_vars = include.route53_zones.locals.env_vars.module_config.child_zone
}

inputs = merge(local.module_vars)
