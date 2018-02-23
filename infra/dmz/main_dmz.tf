variable "ami_id" {}
variable "instance_type_needed" {}
variable "tagname" {}
variable "subnetID" {}
variable "az" {}
variable "security_group" {}

resource "aws_instance" "dmc1" {
  ami                    = "${var.ami_id}"
  instance_type          = "${var.instance_type_needed}"
  subnet_id              = "${var.subnetID}"
  key_name               = "${var.key_name}"

  vpc_security_group_ids = ["${var.security_group}"]

  tags {
    Name = "${var.tagname}"
  }
}