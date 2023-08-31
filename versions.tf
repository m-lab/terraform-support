terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.64.0"
      configuration_aliases = [
        google.data-pipeline,
        google.platform-cluster
      ]
    }
  }
}
