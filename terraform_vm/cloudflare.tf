terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

# Zone
data "cloudflare_zones" "cf_zones" {
  filter {
    name = var.domain
  }
}

# DNS A record
resource "cloudflare_record" "dns_record" {
  zone_id = data.cloudflare_zones.cf_zones.zones[0].id
  name    = "rest-api${terraform.workspace == "production" ? "" : "-${terraform.workspace}"}"
  value   = google_compute_address.ip_address.address
  type    = "A"
  proxied = true
}