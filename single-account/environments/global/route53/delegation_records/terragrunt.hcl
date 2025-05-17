include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "route53_records" {
  path   = find_in_parent_folders("_common/route53_records.hcl")
  expose = true
}

dependency "parent_zone" {
  config_path = "${get_repo_root()}/single-account/environments/global/route53/parent_zone"
  mock_outputs = {
    zone_id = "zone_id"
    }
}

dependency "local_child_zone" {
  config_path = "${get_repo_root()}/single-account/environments/local/route53/child_zone"
  mock_outputs = {
    route53_zone_name_servers = {
      "local.nixknight.com" = [
        "<ns1>",
        "<ns2>",
        "<ns3>",
        "<ns4>"
      ]
    }
  }
}

inputs = {
  zone_id = dependency.parent_zone.outputs.zone_id
  records = [
    {
      name    = "local"
      type    = "NS"
      ttl     = 300
      records = dependency.local_child_zone.outputs.route53_zone_name_servers["local.nixknight.com"]
    }
  ]
}
