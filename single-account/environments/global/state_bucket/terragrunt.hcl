include {
  path = find_in_parent_folders()
}

include "s3_bucket" {
  path   = "../../_common/s3_bucket.hcl"
  expose = true
}

locals {
  module_vars = include.s3_bucket.locals.env_vars.module_config.state_bucket
}

inputs = merge(
  local.module_vars,
  {
    attach_policy = true
    policy = jsonencode(
      yamldecode(
        templatefile(
          "${get_repo_root()}/templates/policies/state_bucket_policy.yaml.tftpl",
          {
            bucket_name = local.module_vars.bucket
            account_id  = "${get_aws_account_id()}"
          }
        )
      )
    )
  }
)
