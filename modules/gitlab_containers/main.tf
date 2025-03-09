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

resource "docker_image" "gitlab" {
  name         = "gitlab/gitlab-ce:latest"
  keep_locally = true
}

resource "docker_image" "gitlab-runner" {
   name         = "gitlab/gitlab-runner:alpine"
   keep_locally = true 
}

resource "docker_network" "bridge_network" {
  name = var.network_name
  driver = var.network_driver
}

resource "docker_container" "gitlab-ce" {
  image = docker_image.gitlab.image_id
  name  = "gitlab-ce"
  hostname = var.hostname
  env = var.env_values
  ports {
    internal = 80
    external = 8080
  }
  ports {
    internal = 443
    external = 8443
  }
  volumes {
    host_path = "/c/Users/Anthony/Documents/Repo/Gitlab/config"
    container_path = "/etc/gitlab"  
  }
  volumes {
    host_path = "/c/Users/Anthony/Documents/Repo/Gitlab/logs"
    container_path = "/etc/log/gitlab"   
  }
  volumes {
    host_path = "/c/Users/Anthony/Documents/Repo/Gitlab/data"
    container_path = "/etc/opt/gitlab"
  }
  networks_advanced {
    name = var.network_name
  }
}

resource "docker_container" "gitlab-runner" {
  image = docker_image.gitlab-runner.image_id
  name  = "gitlab-runner"
  volumes {
    host_path = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }
  volumes {
    host_path = "/c/Users/Anthony/Documents/Repo/Gitlab/gitlab-runner"
    container_path = "/etc/gitlab-runner"
  }
  networks_advanced {
    name = var.network_name
  }
}
