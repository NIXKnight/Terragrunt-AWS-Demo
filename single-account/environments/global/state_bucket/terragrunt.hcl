include {
  path = find_in_parent_folders()
}

include "s3_bucket" {
  path   = "../../_common/s3_bucket.hcl"
  expose = true
}

dependency "state_bucket_kms_key" {
  config_path = "../state_bucket_kms_key"

  mock_outputs = {
    key_arn = "mock_arn"
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}

locals {
  module_vars = include.s3_bucket.locals.env_vars.module_config.state_bucket
}

inputs = merge(
  local.module_vars,
  {
    server_side_encryption_configuration = {
      rule = {
        apply_server_side_encryption_by_default = {
          kms_master_key_id  = "${dependency.state_bucket_kms_key.outputs.key_arn}"
          sse_algorithm      = "aws:kms"
        }
      }
    }

    attach_policy = true
    policy        = jsonencode(
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
