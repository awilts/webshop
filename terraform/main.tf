terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.1.0"
    }
  }
}

locals {
  project  = "wilts-webshop-2"
  location = "europe-west3"
}

provider "google" {
  credentials = file("terraform-credentials.json")
  project     = local.project
  region      = local.location
}

#enable required services
variable "gcp_service_list" {
  description ="The list of apis necessary for the project"
  type = list(string)
  default = [
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com"
  ]
}
resource "google_project_service" "gcp_services" {
  for_each = toset(var.gcp_service_list)
  project = local.project
  service = each.key
}

# Create Github Action Account with permissions
resource "google_service_account" "gha_service_account" {
  depends_on = [google_project_service.gcp_services]

  account_id   = "gh-actions-account"
  display_name = "Service Account for Deployments from Github Actions"
}
resource "google_project_iam_member" "gha-run-admin" {
  project = local.project
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.gha_service_account.email}"
}
resource "google_project_iam_member" "gha-storage-admin" {
  project = local.project
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.gha_service_account.email}"
}
resource "google_project_iam_member" "gha-service-account-user" {
  project = local.project
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.gha_service_account.email}"
}
resource "google_project_iam_member" "gha-registry-service-agent" {
  project = local.project
  role    = "roles/containerregistry.ServiceAgent"
  member  = "serviceAccount:${google_service_account.gha_service_account.email}"
}
resource "google_project_iam_member" "gha-secret-accessor" {
  project = local.project
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.gha_service_account.email}"
}

# Create Cloud Run with public access
resource "google_container_registry" "registry" {
  depends_on = [google_project_service.gcp_services]

  project  = local.project
  location = "EU"
}
resource "google_cloud_run_service" "webshop" {
  depends_on = [google_project_service.gcp_services]

  name     = "cloudrun-webshop"
  location = local.location

  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }
}
data "google_iam_policy" "noauth" {
  binding {
    role    = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}
resource "google_cloud_run_service_iam_policy" "noauth" {
  depends_on = [google_project_service.gcp_services]

  location = google_cloud_run_service.webshop.location
  project  = google_cloud_run_service.webshop.project
  service  = google_cloud_run_service.webshop.name
  policy_data = data.google_iam_policy.noauth.policy_data
}