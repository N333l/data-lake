
variable "region" {}
variable "access_key" {}
variable "secret_key" {}

variable "instance_type" {
  default = "t2.micro"
}

variable "base_ami" {
  description = "Amazon Linux AMI"
}
