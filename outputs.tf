# ─────────────────────────────────────────────────────────────────────────────
# outputs.tf
# ─────────────────────────────────────────────────────────────────────────────
output "vpc_endpoint_ids" {
  description = "Map of service component => VPC Endpoint ID"
  value       = { for k, ep in aws_vpc_endpoint.cdp_pl : k => ep.id }
}

output "security_group_ids" {
  description = "Map of service component => Security Group ID"
  value       = { for k, sg in aws_security_group.cdp_pl : k => sg.id }
}
