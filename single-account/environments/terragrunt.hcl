locals {
  common_vars       = yamldecode(file("common.yaml"))
  state_bucket_name = yamldecode(file("global/environment.yaml")).module_config.state_bucket.bucket
  dynamodb_table    = yamldecode(file("global/environment.yaml")).module_config.state_locking_table.name
}

# Configure Terragrunt to store state files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = local.state_bucket_name
    key            = "${path_relative_to_include()}/state.json"
    region         = local.common_vars.aws.region
    dynamodb_table = local.dynamodb_table
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# Setup provider
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
variable "aws_provider_default_tags" {
  type = map
}

provider "aws" {
  region = "${local.common_vars.aws.region}"
   default_tags {
    tags = var.aws_provider_default_tags
  }
}
EOF
}

inputs = {
  aws_provider_default_tags = local.common_vars.tags
}
