variable "vpc_id" {}
variable "tagname" {}
variable "named" {}
variable "ingress_port" {}
variable "ingress_from_cidr" {}
variable "egress_port_from" {}
variable "egress_port_to" {}
variable "egress_to_cidr" {}

resource "aws_security_group" "web_sg" {
  name        = "${var.named}"
  description = "Allow all inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = "${var.ingress_port}"
    to_port     = "${var.ingress_port}"
    protocol    = "tcp"
    cidr_blocks = ["${var.ingress_from_cidr}"]
  }

  egress {
    from_port   = "${var.egress_port_from}"
    to_port     = "${var.egress_port_to}"
    protocol    = "tcp"
    cidr_blocks = ["${var.egress_to_cidr}"]
  }

  tags {
    Name = "${var.tagname}"
  }
}

output "sec_grp" {
  value = "${aws_security_group.web_sg.id}"
}