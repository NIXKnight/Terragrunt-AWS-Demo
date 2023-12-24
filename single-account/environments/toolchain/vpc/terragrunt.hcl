include {
  path = find_in_parent_folders()
}

include "vpc" {
  path   = "../../_common/vpc.hcl"
  expose = true
}

locals {
  module_vars = include.vpc.locals.env_vars.module_config.vpc
}

inputs = merge(local.module_vars)
