variable "elb_name" {}
variable "subnet_1" {}
variable "subnet_2" {}
variable "subnet_3" {}
variable "security_group_elb" {}
variable "instance_1" {}
variable "instance_2" {}


# Create a new load balancer
resource "aws_elb" "elb" {
  name            = "${var.elb_name}"
  subnets         = ["${var.subnet_1}", "${var.subnet_2}"]
  security_groups = ["${var.security_group_elb}"]

  listener {
    instance_port     = 22
    instance_protocol = "tcp"
    lb_port           = 22
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:22"
    interval            = 30
  }

  instances                   = ["${var.instance_1}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "app1_elb"
  }
}

output "elb" {
  value = "${aws_elb.elb.id}"
}