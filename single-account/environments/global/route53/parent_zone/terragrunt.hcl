include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  module_vars = yamldecode(file(find_in_parent_folders("environment.yaml"))).module_config.parent_zone
}

inputs = merge(local.module_vars)
