variable "vpc_id" {}
variable "tagname" {}

resource "aws_internet_gateway" "dev_IG" {
 vpc_id     = "${var.vpc_id}"

  tags {
    Name = "${var.tagname}"
  }
}

output "dev_IG" {
  value = "${aws_internet_gateway.dev_IG.id}"
}