terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.82.0"
      configuration_aliases = [
        google.data-pipeline,
        google.platform-cluster
      ]
    }
  }
}
