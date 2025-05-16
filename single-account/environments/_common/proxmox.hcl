locals {
  common_vars = yamldecode(file("${get_repo_root()}/single-account/environments/common.yaml")).terraform.remote_modules.proxmox_vm
  env_vars    = yamldecode(file("${path_relative_to_include()}/../environment.yaml"))

  module_source_url = local.common_vars.source
  module_version    = local.common_vars.version
}

terraform {
  source = "${local.module_source_url}?ref=${local.module_version}"
}
