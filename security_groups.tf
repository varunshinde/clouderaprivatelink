# ─────────────────────────────────────────────────────────────────────────────
# security_groups.tf
# ─────────────────────────────────────────────────────────────────────────────
resource "aws_security_group" "cdp_pl" {
  for_each = local.private_link_services

  name        = "cdp-${var.aws_region}.${each.value.service_name}-${upper(each.key)}-sg"
  description = "CDP Private Link SG for ${each.key} (${each.value.service_name})"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS from anywhere (tighten if required)"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.effective_tags,
    {
      Name             = "cdp-${var.aws_region}.${each.value.service_name}-${upper(each.key)}"
      ServiceComponent = each.key
      Created-By       = "Terraform"
    }
  )
}
