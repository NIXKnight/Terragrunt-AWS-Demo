locals {
  common_vars = yamldecode(file("${find_in_parent_folders()}/../common.yaml")).terraform.remote_modules.s3
  env_vars    = yamldecode(file("${path_relative_to_include()}/../environment.yaml"))

  module_source_url = local.common_vars.source
  module_version    = local.common_vars.version
}

terraform {
  source = "${local.module_source_url}?ref=${local.module_version}"
}
