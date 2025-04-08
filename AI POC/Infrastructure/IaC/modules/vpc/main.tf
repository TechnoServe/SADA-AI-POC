resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = var.vpc_name
  auto_create_subnetworks = var.auto_create_subnetworks
}

resource "google_compute_subnetwork" "subnet" {
  for_each       = { for sn in var.subnetworks : sn.name => sn }
  project        = var.project_id
  name           = each.value.name
  region         = each.value.region
  network        = google_compute_network.vpc.id
  ip_cidr_range  = each.value.ip_cidr_range

  dynamic "secondary_ip_range" {
    for_each = each.value.secondary_subnetworks
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }

  depends_on = [google_compute_network.vpc]
}

resource "google_compute_router" "nat_router" {
  project = var.project_id
  name    = "${var.vpc_name}-router"
  network = google_compute_network.vpc.id
  depends_on = [google_compute_network.vpc]
  region = var.region
}

resource "google_compute_router_nat" "cloud_nat" {
  name                               = "${var.vpc_name}-nat"
  project                            = var.project_id
  router                             = google_compute_router.nat_router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES"

  depends_on = [google_compute_router.nat_router]
}



resource "google_compute_route" "default_route" {
  for_each        = { for route in var.routes : route.destination => route }
  project         = var.project_id
  name            = "${var.vpc_name}-route"
  network         = google_compute_network.vpc.id
  dest_range      = each.value.destination
  priority        = each.value.priority
  next_hop_gateway = "default-internet-gateway"

  depends_on = [google_compute_network.vpc]
}

resource "google_compute_firewall" "firewall_rules" {
  for_each = { for rule in var.firewall_rules : rule.id => rule }
  project  = var.project_id
  name     = each.value.id
  network  = google_compute_network.vpc.id
  direction = each.value.direction
  priority  = 1000

  dynamic "allow" {
    for_each = each.value.action == "allow" ? each.value.rules : []
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  source_ranges = each.value.sources
  target_tags   = each.value.targets

  depends_on = [google_compute_network.vpc]
}


resource "google_compute_address" "psc" {
  name          = "${var.vpc_name}-psc"
  project       = var.project_id
  region        = var.region

}
