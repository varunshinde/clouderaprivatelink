# ─────────────────────────────────────────────────────────────────────────────
# variables.tf
# ─────────────────────────────────────────────────────────────────────────────
variable "aws_region" {
  description = "AWS region in which to create the CDP Private Link resources"
  type        = string
}

variable "vpc_id" {
  description = "Target VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs spanning AZs for Interface Endpoints"
  type        = list(string)
}

variable "private_link_json_path" {
  description = "Path to JSON file from `cdp cloudprivatelinks list-private-link-services-for-region`"
  type        = string
  default     = null # Falls back to ./private_link.json when null
}

variable "custom_tags" {
  description = "Custom tags applied to every resource"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "[DEPRECATED] Use custom_tags instead"
  type        = map(string)
  default     = {}
}
