variable "subnetID" {}
variable "RouteTableID" {}

resource "aws_route_table_association" "a" {
  subnet_id      = "${var.subnetID}"
  route_table_id = "${var.RouteTableID}"
}