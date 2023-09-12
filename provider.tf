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
  project     = "dxs-apac"
  region      = "australia-southeast1"
  zone        = "australia-southeast1-a"
}