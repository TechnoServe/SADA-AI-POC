variable "project_id" {
  description = "The ID of the GCP project."
  type        = string
}
variable "region" {
  description = "region"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC network."
  type        = string
}

variable "auto_create_subnetworks" {
  description = "Whether to auto-create subnetworks."
  type        = bool
  default     = false
}

variable "subnetworks" {
  description = "List of subnetworks to create."
  type = list(object({
    name       = string
    region     = string
    ip_cidr_range = string
    secondary_subnetworks = list(object({
      range_name    = string
      ip_cidr_range = string
    }))
  }))
}

variable "cloud_nat" {
  description = "Cloud NAT configuration."
  type = object({
    subnetwork_to_nat = string
  })
}

variable "routes" {
  description = "List of custom routes."
  type = list(object({
    destination   = string
    priority      = number
    next_hop_type = string
  }))
}

variable "firewall_rules" {
  description = "List of firewall rules."
  type = list(object({
    id        = string
    action    = string
    direction = string
    sources   = list(string)
    targets   = list(string)
    rules = list(object({
      protocol = string
      ports    = list(number)
    }))
  }))
}

variable "private_service_connection" {
  description = "Private service connection configuration."
  type = object({
    import_custom_routes = bool
    export_custom_routes = bool
  })
}

