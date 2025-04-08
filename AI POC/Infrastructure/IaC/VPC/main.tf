
module "vpc" {
  source = "../modules/vpc"  # Update this path to where your VPC module is located

  project_id                 = var.project_id
  region                     = var.region
  vpc_name                   = var.vpc_name
  auto_create_subnetworks    = var.auto_create_subnetworks
  subnetworks                = var.subnetworks
  cloud_nat                  = var.cloud_nat
  routes                     = var.routes
  firewall_rules             = var.firewall_rules
  private_service_connection = var.private_service_connection
}