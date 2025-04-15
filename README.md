# =============================================================================
# Cloudera CDP Private Link with Authorization Terraform implementation
# =============================================================================
# File layout:
#   versions.tf        – Terraform & provider requirements
#   variables.tf       – Input variables
#   locals.tf          – JSON parsing & data shaping
#   security_groups.tf – aws_security_group resources
#   vpc_endpoints.tf   – aws_vpc_endpoint resources
#   outputs.tf         – Useful outputs
# =============================================================================

Cloudera CDP Private Link – Terraform Module

A one‑stop Terraform implementation that converts the JSON you obtain from
cdp cloudprivatelinks list-private-link-services-for-region into the AWS
resources required to establish Cloudera CDP Private Link connectivity:

One interface VPC endpoint per CDP service component (API, DBUSAPI,
CCMv2, Monitoring, ConsoleAuth, …).

A dedicated security group for each endpoint.

A concise set of outputs you can feed into subsequent modules.


Prerequisites
# ================================================================================

Requirement      Version

Terraform        1.5 or later
AWS Provider     5.40 or later
AWS CLI          configured profile/credentials with permission to create    
                 EC2 Interface Endpoints and Security Groups
CDP CLI          to generate the Private Link JSON

IAM Permissions
The caller needs ec2:CreateSecurityGroup, ec2:AuthorizeSecurityGroup*,
ec2:CreateVpcEndpoint, and tagging permissions (ec2:CreateTags).


Quick Start

Export the CDP JSON for your target region:

```console
REGION=us-east-1
cdp cloudprivatelinks list-private-link-services-for-region \
    --region "$REGION" > private_link.json
```

Create a terraform.tfvars file:

aws_region             = "us-east-1"
vpc_id                 = "vpc-123456789XXXXX"
subnet_ids             = [
  "subnet-06XXXXXXXXXXXXXXX",
  "subnet-08XXXXXXXXXXXXXXX",
  "subnet-09XXXXXXXXXXXXXXX",
]

# Optional: custom tags applied to *every* resource
custom_tags = {
  Environment = "dev"
  Owner       = "data-platform-team"
}

Initialize & plan:

terraform init
terraform plan

Apply (creates SGs + Interface Endpoints):

terraform apply

