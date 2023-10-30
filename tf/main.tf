# Defining variables for Region, and AK/SK.
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

# Configure the HUAWEI CLOUD provider.
provider "huaweicloud" {
    region = var.region
    access_key  = var.access_key
    secret_key  = var.secret_key
}

# Create a VPC
resource "huaweicloud_vpc" "example" {
    name = "terraform_vpc"
    cidr = "192.168.0.0/16"
  
}

# Creating a subnet inside the VPC
resource "huaweicloud_vpc_subnet" "subnet-example-tf" {
    name        = "subnet-terraform"
    cidr        = "192.168.1.0/24"
    gateway_ip  = "192.168.1.254"
    vpc_id      = huaweicloud_vpc.example.id
}

data "huaweicloud_availability_zones" "myaz" {}

data "huaweicloud_compute_flavors" "myflavor" {
    availability_zone  = data.huaweicloud_availability_zones.myaz.names[0]
    performance_type     = "normal"
    cpu_core_count      = 1
    memory_size         = 2

}

resource "random_password" "password" {
  length            = 16
  special           = true
  override_special  = "!@#$%*"
}

resource "huaweicloud_compute_instance" "basic" {
  name              = "basic"
  admin_pass        = random_password.password.result
  image_id          = "66e4081e-902c-4575-abb3-4c3d99cbedb9" #TYPE YOUR IMAGE ID HERE
  flavor_id         = data.huaweicloud_compute_flavors.myflavor.ids[0]
  availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
  security_group_ids   = ["3fadce09-51d8-473f-9fe4-368be59b1394"]

  network {
    uuid = huaweicloud_vpc_subnet.subnet-example-tf.id
  }
  
}

