terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.1.0"
    }
  }
}

variable "AUTH_KEY" {
  type        = string
  sensitive   = true
}
variable "AUTH_URL" {
  type        = string
  sensitive   = true
}
variable "PASSWORD" {
  type        = string
  sensitive   = true
}
variable "USER" {
  type        = string
  sensitive   = true
}
variable "FFT_API_URL" {
  type        = string
  sensitive   = true
}

locals {
  project          = "wilts-webshop-2"
  location         = "europe-west3"
  secrets          = {
    auth-key    = var.AUTH_KEY
    auth-url    = var.AUTH_URL
    fft-api-url = var.FFT_API_URL
    password    = var.PASSWORD
    user        = var.USER
  }
  gcp_service_list = [
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com"
  ]
  gha-roles        = [
    "roles/run.admin",
    "roles/storage.admin",
    "roles/iam.serviceAccountUser",
    "roles/containerregistry.ServiceAgent",
    "roles/secretmanager.secretAccessor"
  ]
}

provider "google" {
  credentials = file("terraform-credentials.json")
  project     = local.project
  region      = local.location
}

resource "google_project_service" "gcp_services" {
  for_each = toset(local.gcp_service_list)
  project  = local.project
  service  = each.key
}

resource "google_container_registry" "registry" {
  depends_on = [google_project_service.gcp_services]
  project    = local.project
  location   = "EU"
}

# Create Github Action Account with permissions
resource "google_service_account" "gha_service_account" {
  depends_on   = [google_project_service.gcp_services]
  project      = local.project
  account_id   = "gh-actions-account"
  display_name = "Service Account for Deployments from Github Actions"
}
resource "google_project_iam_member" "gha-roles" {
  for_each = toset(local.gha-roles)
  project  = local.project
  role     = each.key
  member   = "serviceAccount:${google_service_account.gha_service_account.email}"
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
data "google_project" "project" {}
resource "google_secret_manager_secret_iam_member" "secret-access" {
  for_each  = local.secrets
  secret_id = google_secret_manager_secret.secret[each.key].id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}
