terraform {
  required_providers {
    google = {
      source  = "hashicorp/google-beta"
      version = "4.82.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "google" {
  project     = var.project
  region      = var.region
  zone        = var.zone
}