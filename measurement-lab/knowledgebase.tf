module "knowledgebase" {
  source = "../modules/knowledgebase"

  providers = {
    google = google.knowledgebase
  }
}
