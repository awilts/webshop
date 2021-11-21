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
data "google_project" "project" {
}

resource "google_secret_manager_secret" "auth-key" {
  secret_id = "auth-key"

  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret_version" "secret-version-data-auth-key" {
  secret      = google_secret_manager_secret.auth-key.id
  secret_data = "dummy"
}
resource "google_secret_manager_secret_iam_member" "secret-access-auth-key" {
  project    = data.google_project.project.id
  secret_id = google_secret_manager_secret.auth-key.id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}

resource "google_secret_manager_secret" "auth-url" {
  secret_id = "auth-url"
  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret_version" "secret-version-data-auth-url" {
  secret      = google_secret_manager_secret.auth-url.id
  secret_data = "dummy"
}
resource "google_secret_manager_secret_iam_member" "secret-access-auth-url" {
  project    = data.google_project.project.id
  secret_id = google_secret_manager_secret.auth-url.id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}


resource "google_secret_manager_secret" "password" {
  secret_id = "password"
  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret_version" "secret-version-data-password" {
  secret      = google_secret_manager_secret.password.id
  secret_data = "dummy"
}
resource "google_secret_manager_secret_iam_member" "secret-access-password" {
  project    = data.google_project.project.id
  secret_id = google_secret_manager_secret.password.id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}

resource "google_secret_manager_secret" "user" {
  secret_id = "user"
  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret_version" "secret-version-data-user" {
  secret      = google_secret_manager_secret.user.id
  secret_data = "dummy"
}
resource "google_secret_manager_secret_iam_member" "secret-access-user" {
  project    = data.google_project.project.id
  secret_id = google_secret_manager_secret.user.id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}

resource "google_secret_manager_secret" "fft-api-url" {
  secret_id = "fft-api-url"
  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret_version" "secret-version-data-fft-api-url" {
  secret      = google_secret_manager_secret.fft-api-url.id
  secret_data = "dummy"
}
resource "google_secret_manager_secret_iam_member" "secret-access-fft-api-url" {
  project    = data.google_project.project.id
  secret_id = google_secret_manager_secret.fft-api-url.id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}