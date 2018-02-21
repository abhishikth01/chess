variable "destination_cidr" {}
variable "target" {}
variable "vpc_id" {}
variable "tagname" {}

resource "aws_route_table" "dev_routetable" {
  vpc_id     = "${var.vpc_id}"

  route {
    cidr_block = "${var.destination_cidr}"
    gateway_id = "${var.target}"
  }

  tags {
    Name = "${var.tagname}"
  }
}