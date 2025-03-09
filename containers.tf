terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {
  host    = "npipe:////.//pipe//docker_engine"
}

module "gitlab-docker" {
  source = "./modules/gitlab_containers"
  env_values = var.env_values
  network_name = var.network_name
  network_driver = var.network_driver
  hostname = var.hostname
}