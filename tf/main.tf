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

  depends_on = [
    google_project_service.enable-required-apis
  ]
}

resource "google_compute_subnetwork" "subnet" {
  name                     = var.subnet-name
  provider                 = google-beta
  ip_cidr_range            = "10.1.2.0/24"
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true

  depends_on = [
    google_project_service.enable-required-apis
  ]
}

resource "google_service_account" "notebook_service_account" {
  account_id   = "notebook-sa"
  display_name = "Terraform-managed SA for Notebook"
}

resource "google_project_iam_member" "notebook_bq_admin" {
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${google_service_account.notebook_service_account.email}"
}

resource "google_project_iam_member" "notebook_bq_dataowner" {
  role    = "roles/bigquery.dataOwner"
  member  = "serviceAccount:${google_service_account.notebook_service_account.email}"
}

resource "google_project_iam_member" "notebook_storage_admin" {
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.notebook_service_account.email}"
}

resource "google_project_iam_member" "notebook_storage_objectadmin" {
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.notebook_service_account.email}"
}

resource "google_project_iam_member" "notebook_vertex_user" {
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.notebook_service_account.email}"
}

resource "google_compute_network" "my_network" {
  name = "wbi-test-default"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "my_subnetwork" {
  name   = "wbi-test-default"
  network = google_compute_network.my_network.id
  region = "us-central1"
  ip_cidr_range = "10.0.1.0/24"
}

resource "google_workbench_instance" "instance" {
  name = "cetechday"
  location = var.region

  gce_setup {
    machine_type = "ne2-standard-4" 

    shielded_instance_config {
      enable_secure_boot = false
      enable_vtpm = false
      enable_integrity_monitoring = false
    }
    disable_public_ip = true
    service_accounts {
      email = google_service_account.notebook_service_account.email
    }
    network_interfaces {
      network = google_compute_network.vpc.id
      subnet = google_compute_subnetwork.subnet.id
      nic_type = "GVNIC"
    }
    metadata = {
      terraform = "true"
    }
    enable_ip_forwarding = true

  }

  disable_proxy_access = "true"

  desired_state = "ACTIVE"

}

resource "google_service_account" "text2sql_sservice_account" {
  account_id   = "text2sql-sa"
  display_name = "Terraform-managed SA for Text2SQL"
}

resource "google_project_iam_member" "text2sql_bq_dataviewer" {
  role    = "roles/bigquery.dataViewer"
  member  = "serviceAccount:${google_service_account.text2sql_sservice_account.email}"
}

resource "google_project_iam_member" "text2sql_bq_jobUser" {
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.text2sql_sservice_account.email}"
}

resource "google_project_iam_member" "text2sql_cloudrun_invoker" {
  role    = "roles/run.onvoker"
  member  = "serviceAccount:${google_service_account.text2sql_sservice_account.email}"
}






