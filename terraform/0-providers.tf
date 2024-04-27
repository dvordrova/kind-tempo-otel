terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.2.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.10.1"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
  }

  required_version = ">= 1.0.0"
}

provider "kind" {
}

provider "helm" {
  kubernetes {
    config_path = pathexpand(var.kind_cluster_config_path)
  }
}
