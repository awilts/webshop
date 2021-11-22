terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.1.0"
    }
  }
}

data "google_project" "project" {}

locals {
  project  = "wilts-webshop-2"
  location = "europe-west3"
  secrets  = {
    auth-key    = "dummy"
    auth-url    = "dummy"
    fft-api-url = "dummy"
    password    = "dummy"
    user        = "dummy"
  }
}

provider "google" {
  credentials = file("terraform-credentials.json")
  project     = local.project
  region      = local.location
}

#enable required services
variable "gcp_service_list" {
  description = "The list of apis necessary for the project"
  type        = list(string)
  default     = [
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com"
  ]
}
resource "google_project_service" "gcp_services" {
  for_each = toset(var.gcp_service_list)
  project  = local.project
  service  = each.key
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

# secrets
resource "google_secret_manager_secret" "secret" {
  for_each  = local.secrets
  secret_id = each.key
  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret_version" "secret-version-data" {
  for_each    = local.secrets
  secret      = google_secret_manager_secret.secret[each.key].id
  secret_data = each.value
}
resource "google_secret_manager_secret_iam_member" "secret-access" {
  for_each  = local.secrets
  secret_id = google_secret_manager_secret.secret[each.key].id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}
