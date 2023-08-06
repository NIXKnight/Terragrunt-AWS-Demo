locals {
  vars     = yamldecode(file("common.yaml"))
  env_vars = yamldecode(file("${path_relative_to_include()}/../environment.yaml"))

  environment_tags = local.env_vars.tags
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
  region = "${local.vars.aws.region}"
   default_tags {
    tags = var.aws_provider_default_tags
  }
}
EOF
}

inputs = {
  aws_provider_default_tags = merge(local.vars.tags, local.environment_tags)
}
