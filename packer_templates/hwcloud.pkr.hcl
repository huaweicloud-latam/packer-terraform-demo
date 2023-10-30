packer {
  required_plugins {
    huaweicloud = {
      version = " >= 1.0.0"
      source  = "github.com/huaweicloud/huaweicloud"
    }
  }
}
 
variable "access_key" {
  type    = string
  default = null
}

variable "secret_key" {
  type    = string
  default = null
}

variable "region" {
  type    = string
  default = null
}

variable "az"{
    type    = string
    default = null
}

source "huaweicloud-ecs" "artifact" {
  access_key        = var.access_key
  secret_key        = var.secret_key
  region            = var.region 
  availability_zone = var.az 
  flavor            = "s6.small.1"
  source_image_name = "Ubuntu 22.04 server 64bit"
  image_name        = "Ubuntu-2204-image-powered-by-Packer"
  image_tags = {
    builder = "packer"
    os      = "Ubuntu-22.04-server"
  }
 
  ssh_username       = "root"
  eip_type           = "5_bgp"
  eip_bandwidth_size = 5
}
 
build {
  sources = ["source.huaweicloud-ecs.artifact"]
 
  provisioner "shell" {
    inline = ["apt-get update -y"]
  }
 
  post-processor "manifest" {
    strip_path = true
    output     = "packer-result.json"
  }
}
