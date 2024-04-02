resource "google_project_service" "enable-cloud-resource-manager-api" {

  project = var.project_id
  service = "cloudresourcemanager.googleapis.com"

  timeouts {
    create = "15m"
    update = "15m"
  }

  disable_dependent_services = false
  disable_on_destroy         = false

}

resource "google_project_service" "enable-required-apis" {

  for_each = toset([
    "monitoring.googleapis.com",
    "compute.googleapis.com",
    "aiplatform.googleapis.com",
    "artifactregistry.googleapis.com",
    "servicenetworking.googleapis.com",
    "vpcaccess.googleapis.com",
    "notebooks.googleapis.com",
    "bigquery.googleapis.com",
    "dataproc.googleapis.com"
  ])
  project = var.project_id
  service = each.value

  timeouts {
    create = "15m"
    update = "15m"
  }

  disable_dependent_services = false
  disable_on_destroy         = false

  depends_on = [
    google_project_service.enable-cloud-resource-manager-api
  ]

}

resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = var.vpc-name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name                     = var.subnet-name
  provider                 = google-beta
  ip_cidr_range            = "10.1.2.0/24"
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true
}