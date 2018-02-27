variable "destination_cidr" {}
variable "target" {}
variable "vpc_id" {}
variable "tagname" {}
variable "nat_inst" {}

resource "aws_route_table" "dev_routetable" {
  vpc_id     = "${var.vpc_id}"

  route {
    cidr_block = "${var.destination_cidr}"
    gateway_id = "${var.target}"
    instance_id = "${var.nat_inst}"
  }

  tags {
    Name = "${var.tagname}"
  }
}

output "dev_routetable" {
  value = "${aws_route_table.dev_routetable.id}"
}