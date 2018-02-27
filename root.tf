module "mod_dev_vpc" {
  source = "./network/vpc/"

  cidr_range = "10.1.0.0/16"
  }

module "mod_dev_pub_sub1" {
  source = "./network/subnets/"
  
  vpc_id = "${module.mod_dev_vpc.dev_vpc_id}"
  cidr = "10.1.1.0/24"
  tagname = "pub_subnet_1"
  need_public_ip = "true"
  az = "us-east-1a"
}

module "mod_dev_pub_sub2" {
  source = "./network/subnets/"
  
  vpc_id = "${module.mod_dev_vpc.dev_vpc_id}"
  cidr = "10.1.2.0/24"
  tagname = "pub_subnet_2"
  need_public_ip = "true"
  az = "us-east-1b"
}

module "mod_dev_pvt_sub1" {
  source = "./network/subnets/"
  
  vpc_id = "${module.mod_dev_vpc.dev_vpc_id}"
  cidr = "10.1.3.0/24"
  tagname = "pvt_subnet_1"
  need_public_ip = "false"
  az = "us-east-1a"
}
module "mod_dev_pvt_sub2" {
  source = "./network/subnets/"
  
  vpc_id = "${module.mod_dev_vpc.dev_vpc_id}"
  cidr = "10.1.4.0/24"
  tagname = "pvt_subnet_2"
  need_public_ip = "false"
  az = "us-east-1b"
}

module "mod_dev_IG" {
  source = "./network/internetGW/"
  vpc_id = "${module.mod_dev_vpc.dev_vpc_id}"
  tagname = "dev_internetGW"

}

module "mod_dev_pub_route" {
  source = "./network/routeTable/"

  vpc_id = "${module.mod_dev_vpc.dev_vpc_id}"
  destination_cidr = "0.0.0.0/0"
  target = "${module.mod_dev_IG.dev_IG}"
  nat_inst = ""

  tagname = "dev_public_route"
}

module "mod_dev_rt_association1" {
  source = "./network/rtAsct/"

  subnetID = "${module.mod_dev_pub_sub1.dev_subnetID}"
  RouteTableID = "${module.mod_dev_pub_route.dev_routetable}"
  
}

module "mod_dev_rt_association2" {
  source = "./network/rtAsct/"

  subnetID = "${module.mod_dev_pub_sub2.dev_subnetID}"
  RouteTableID = "${module.mod_dev_pub_route.dev_routetable}"
  
}

module "mod_dev_secGrp_dmz" {
  source = "./network/securityGrp/"
  vpc_id = "${module.mod_dev_vpc.dev_vpc_id}"
  named = "sec_grp_dmz"
  tagname = "securityGrp_dmz"
  ingress_port = "22"
  ingress_from_cidr = "0.0.0.0/0"
  egress_port_from = "0"
  egress_port_to = "65535"
  egress_to_cidr = "0.0.0.0/0"
  
}


module "mod_dev_dmz_ec2" {
  source = "./infra/dmz/"
  ami_id = "ami-97785bed"
  instance_type_needed = "t2.nano"
  
  tagname = "dmz_box1"
  subnetID = "${module.mod_dev_pvt_sub1.dev_subnetID}"
  security_group = "${module.mod_dev_secGrp_dmz.sec_grp}"
  az = "us-east-1a"
  source_destchk = "true"
}

module "mod_dev_secGrp_elb" {
  source = "./network/securityGrp/"
  vpc_id = "${module.mod_dev_vpc.dev_vpc_id}"
  named = "sec_grp_elb"
  tagname = "securityGrp_dmz"
  ingress_port = "22"
  ingress_from_cidr = "0.0.0.0/0"
  egress_port_from = "0"
  egress_port_to = "65535"
  egress_to_cidr = "0.0.0.0/0"
  
}

module "mod_dev_dmz_nat" {
  source = "./infra/dmz/"
  ami_id = "ami-01623d7b"
  instance_type_needed = "t2.nano"
  
  tagname = "dmz_box1"
  subnetID = "${module.mod_dev_pub_sub1.dev_subnetID}"
  security_group = "${module.mod_dev_secGrp_dmz.sec_grp}"
  az = "us-east-1a"
  source_destchk = "false"
}


module "mod_dev_pvt_route" {
  source = "./network/routeTable/"

  vpc_id = "${module.mod_dev_vpc.dev_vpc_id}"
  destination_cidr = "0.0.0.0/0"
  target = ""
  nat_inst = "${module.mod_dev_dmz_nat.dmc1}"

  tagname = "dev_private_route"
}

module "mod_dev_rt_association3" {
  source = "./network/rtAsct/"

  subnetID = "${module.mod_dev_pvt_sub1.dev_subnetID}"
  RouteTableID = "${module.mod_dev_pvt_route.dev_routetable}"
  
}

module "mod_dev_rt_association4" {
  source = "./network/rtAsct/"

  subnetID = "${module.mod_dev_pvt_sub2.dev_subnetID}"
  RouteTableID = "${module.mod_dev_pvt_route.dev_routetable}"
  
}


module "mod_dev_dmz_elb" {
  source = "./infra/elb/"

  elb_name = "dev-dmz-elb"
  subnet_1 = "${module.mod_dev_pub_sub1.dev_subnetID}"
  subnet_2 = "${module.mod_dev_pub_sub2.dev_subnetID}"
  instance_1 = "${module.mod_dev_dmz_ec2.dmc1}"
  instance_2 = ""
  subnet_3 = ""
  security_group_elb = "${module.mod_dev_secGrp_elb.sec_grp}"
  
}