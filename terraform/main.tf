terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.1.0"
    }
  }
}

provider "google" {
  credentials = file("terraform-credentials.json")
  project     = "wilts-webshop"
  region      = "europe-west3"
}

resource "google_container_registry" "registry" {
  project  = "wilts-webshop"
  location = "EU"
}