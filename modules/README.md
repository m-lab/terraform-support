# Submodules

This directory contains Terraform sub- or child-modules that can be included as
necessary in any of the project root modules. This allows us the flexibility of
including, or not, any module in any project, as needed.

A modules in this directory should be named after a logically grouped set of
infrastruture that it implement.

## Module list

### data-pipeline

data-pipeline implements infrastructure associated with the ETL pipeline.

### foundations

foundations implements instrastructure that doesn't neatly fit into any other
logical grouping of resources, or that may be used by more than one logical
resource group. For example, defining the IAM bindings for the default Cloud
Build service account, which may perform builds related to any or all logical
resource groups, or which may perform builds not relevant to any particular
resource group.

### platform-cluster

platform-cluster implements infrastructure associated with M-Lab's primary
platform kubernetes cluster (i.e., where all experiments run).

### visualizations

visualizations implements infrastructure related to visualizations of the M-Lab
data. These visualizations may or may not be public resources.
