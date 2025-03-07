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

resource "docker_container" "gitlab-ce" {
  image = docker_image.gitlab.image_id
  name  = "gitlab-ce"
  hostname = "localhost"
  env = ["GITLAB_OMNIBUS_CONFIG = external_url http://localhost"]
  ports {
    internal = 80
    external = 8080
  }
  ports {
    internal = 443
    external = 8443
  }
  mounts {
    target = "/etc/gitlab"
    source = "C:/Users/Anthony/Documents/Repo/Gitlab/config"
    type = "bind"
  }
  mounts {
    target = "/etc/log/gitlab"
    source = "C:/Users/Anthony/Documents/Repo/Gitlab/logs"
    type = "bind"
  }
  mounts {
    target = "/etc/opt/gitlab"
    source = "C:/Users/Anthony/Documents/Repo/Gitlab/data"
    type = "bind"
  }
  networks_advanced {
    name = "gitlab-network"
  }
}

resource "docker_container" "gitlab-runner" {
  image = docker_image.gitlab-runner.image_id
  name  = "gitlab-runner"
  mounts {
    target = "/var/run/docker.sock"
    source = "/var/run/docker.sock"
    type = "bind"
  }
    mounts {
    target = "/etc/gitlab-runner"
    source = "C:/Users/Anthony/Documents/Repo/Gitlab/gitlab-runner"
    type = "bind"
  }
    networks_advanced {
    name = "gitlab-network"
  }
}
