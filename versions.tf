terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.12.0"
      configuration_aliases = [
        google.data-pipeline,
        google.foundations,
        google.platform-cluster,
        google.visualizations
      ]
    }
  }
}
