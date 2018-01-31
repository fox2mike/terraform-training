#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-66506c1c
#
# Your subnet ID is:
#
#     subnet-849ca4cf
#
# Your security group ID is:
#
#     sg-3ee83749
#
# Your Identity is:
#
#     customer-training-crab

variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
  default = "us-east-1"
}

variable "number_of_webheads" {
  default = "2"
}

terraform {
  backend "atlas" {
    name = "smani/training"
  }
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "web" {
  ami           = "ami-66506c1c"
  instance_type = "t2.micro"

  subnet_id              = "subnet-849ca4cf"
  vpc_security_group_ids = ["sg-3ee83749"]

  tags {
    "Identity" = "customer-training-crab"
    "Subnet"   = "subnet-849ca4cf"
    "Foo"      = "Bar"
    Name       = "web${count.index+1}/${var.number_of_webheads}"
  }

  count = "${var.number_of_webheads}"
}

# module "example" {
#  source = "./example-module"
#  command = "/bin/ls"
#}

output "public_dns" {
  value = ["${aws_instance.web.*.public_dns}"]
}

output "public_ip" {
  value = ["${aws_instance.web.0.public_ip}"]
}
