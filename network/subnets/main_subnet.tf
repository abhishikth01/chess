variable "vpc_id" {}
variable "cidr" {}
variable "tagname" {}
variable "need_public_ip" {}
variable "az" {}

resource "aws_subnet" "dev_subnet" {
  
  vpc_id     = "${var.vpc_id}"
  cidr_block = "${var.cidr}"
  map_public_ip_on_launch = "${var.need_public_ip}"
  availability_zone = "${var.az}"

  tags {
    Name = "${var.tagname}"
  }

}