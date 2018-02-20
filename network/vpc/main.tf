variable "cidr_range" {}

resource "aws_vpc" "dev_vpc" {
  cidr_block = "${var.cidr_range}"

}

output "dev_vpc_id" {
  value = "${aws_vpc.dev_vpc.id}"
}