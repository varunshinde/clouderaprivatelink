# ─────────────────────────────────────────────────────────────────────────────
# locals.tf
# ─────────────────────────────────────────────────────────────────────────────
locals {
  # Merge tags – prefer custom_tags, fall back to deprecated tags
  effective_tags = length(var.custom_tags) > 0 ? var.custom_tags : var.tags

  # Resolve JSON path
  private_link_json_path = coalesce(var.private_link_json_path, "${path.module}/private_link.json")

  # Raw JSON decoded
  private_link_services_raw = jsondecode(file(local.private_link_json_path))

  # List → map keyed by serviceComponent
  private_link_services_all = {
    for svc in local.private_link_services_raw.listPrivateLinkServicesForRegionResults :
    svc.serviceComponent => {
      service_name = svc.privateLinkService
      hostname     = trim(svc.hostname, "[]")
      azs          = trim(svc.availabilityZoneList, "[]")
      tcp_ports    = trim(svc.vpceClientTcpPortList, "[]")
    }
  }

  # Keep only entries whose service_name contains the chosen region
  private_link_services = {
    for k, v in local.private_link_services_all :
    k => v if strcontains(v.service_name, ".${var.aws_region}.")
  }

  services_selected = keys(local.private_link_services)
}
