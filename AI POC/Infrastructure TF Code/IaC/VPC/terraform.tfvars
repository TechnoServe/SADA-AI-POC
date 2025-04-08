project_id      = "ai-poc-sada"
vpc_name        = "custom-vpc"
auto_create_subnetworks = false
region   = "us-central1"


subnetworks = [
  {
    name          = "subnet-1"
    region        = "us-central1"
    ip_cidr_range = "10.0.32.0/22"
    secondary_subnetworks = [
      {
        range_name    = "secondary-subnet-1"
        ip_cidr_range = "172.30.0.0/22"
      },
      {
        range_name    = "secondary-subnet-2"
        ip_cidr_range = "192.168.192.0/22"
      }
    ]
  }
]

cloud_nat = {
  subnetwork_to_nat = "ALL_PRIMARY_SUBNETWORKS_ALL_SECONDARY_SUBNETWORKS"
    region        = "us-central1"
}

routes = [
  {
    destination   = "0.0.0.0/0"
    priority      = 0
    next_hop_type = "INTERNET_GATEWAY"
  }
]

firewall_rules = [
  {
    id        = "allow-ssh"
    action    = "allow"
    direction = "INGRESS"
    sources   = ["10.0.32.0/22"]
    targets   = ["ssh-tag"]
    rules = [
      {
        protocol = "TCP"
        ports    = [22]
      }
    ]
  }
]

private_service_connection = {
#   ip_cidr_range       = "10.0.35.10"
#   ip_cidr_prefix      = 22
  import_custom_routes = false
  export_custom_routes = false
}

