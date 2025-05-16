include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "proxmox" {
  path   = find_in_parent_folders("_common/proxmox.hcl")
  expose = true
}

locals {
  module_vars = include.proxmox.locals.env_vars.module_config.proxmox_vm
  module_vars_private = yamldecode(file("${get_repo_root()}/../../Home-Ops-Internal/terragrunt/proxmox/terragrunt_demo_vms.yaml")).module_config

  # Extract all top-level fields from module_vars_private excluding "vms" variable
  module_vars_private_top_level = {
    for k, v in local.module_vars_private :
      k => v if k != "vms"
  }

  # Merge the VMs from module_vars and module_vars_private
  module_vars_merged_vms = {
    for vm_key in distinct(concat(keys(local.module_vars.vms), keys(local.module_vars_private.vms))) :
      vm_key => merge(
        try(local.module_vars.vms[vm_key], {}),
        try(local.module_vars_private.vms[vm_key], {})
      )
  }

  # Create the final inputs by merging:
  # * The merged vms structure
  # * The top-level fields from module_vars_private
  module_vars_final = merge(
    { for k, v in local.module_vars : k => v if k != "vms" },
    local.module_vars_private_top_level,
    { vms = local.module_vars_merged_vms }
  )
}

inputs = local.module_vars_final
