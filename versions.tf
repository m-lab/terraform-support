terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.40.0"
      configuration_aliases = [
        google.google-oim
      ]
    }
  }
}

