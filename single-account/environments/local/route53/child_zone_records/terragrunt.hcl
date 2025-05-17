include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "route53_records" {
  path   = find_in_parent_folders("_common/route53_records.hcl")
  expose = true
}

dependency "local_child_zone" {
  config_path = "${get_repo_root()}/single-account/environments/local/route53/child_zone"
  mock_outputs = {
    zone_id = "zone_id"
  }
}

dependency "proxmox_vms" {
  config_path = "${get_repo_root()}/single-account/environments/local/proxmox_vms"
  mock_outputs = {
    vm_ips = {
      "vault-server" = "<ip_address>"
    }
  }
}

inputs = {
  zone_id = dependency.local_child_zone.outputs.route53_zone_zone_id["local.nixknight.com"]
  records = [
    {
      name    = "vault"
      type    = "A"
      ttl     = 300
      records = [dependency.proxmox_vms.outputs.vm_ips["vault-server"]]
    }
  ]
}
