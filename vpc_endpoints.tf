# ─────────────────────────────────────────────────────────────────────────────
# vpc_endpoints.tf
# ─────────────────────────────────────────────────────────────────────────────
resource "aws_vpc_endpoint" "cdp_pl" {
  for_each = local.private_link_services

  vpc_id              = var.vpc_id
  service_name        = each.value.service_name
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = [aws_security_group.cdp_pl[each.key].id]
  private_dns_enabled = true

  policy = jsonencode({
    Statement = [{
      Action    = "*"
      Effect    = "Allow"
      Principal = "*"
      Resource  = "*"
    }]
  })

  tags = merge(
    local.effective_tags,
    {
      Name             = "cdp-${var.aws_region}.${each.value.service_name}-${upper(each.key)}"
      ServiceGroup     = "cdp_control_plane"
      ServiceComponent = each.key
      HostName         = each.value.hostname
      Created-By       = "Terraform"
    }
  )
}
