include {
  path = find_in_parent_folders()
}

include "kms" {
  path   = "../../_common/kms.hcl"
  expose = true
}

locals {
  module_vars = include.kms.locals.env_vars.module_config.state_bucket_kms_key
}

inputs = merge(local.module_vars)
