include {
  path = find_in_parent_folders()
}

include "dynamodb" {
  path   = "../../_common/dynamodb.hcl"
  expose = true
}

locals {
  module_vars = include.dynamodb.locals.env_vars.module_config.state_locking_table
}

inputs = merge(local.module_vars)
