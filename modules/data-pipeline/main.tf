provider "google" {
  project = "mlab-sandbox"
}


module "tf-output-projects-mlab-sandbox-ContainerCluster-prometheus-federation-ContainerNodePool-us-central1-c" {
  source = "./tf-output/projects/mlab-sandbox/ContainerCluster/prometheus-federation/ContainerNodePool/us-central1-c"
}


module "tf-output-projects-mlab-sandbox-ContainerCluster-data-processing-ContainerNodePool-us-east1" {
  source = "./tf-output/projects/mlab-sandbox/ContainerCluster/data-processing/ContainerNodePool/us-east1"
}


module "tf-output-projects-mlab-sandbox-ContainerCluster-us-central1-c" {
  source = "./tf-output/projects/mlab-sandbox/ContainerCluster/us-central1-c"
}


module "tf-output-projects-mlab-sandbox-ContainerCluster-us-east1" {
  source = "./tf-output/projects/mlab-sandbox/ContainerCluster/us-east1"
}

