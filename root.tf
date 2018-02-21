module "mod_dev_vpc" {
  source = "./network/vpc/"

  cidr_range = "10.4.0.0/16"
  }

module "mod_dev_pub_sub1" {
  source = "./network/subnets/"
  
  vpc_id = "${module.mod_dev_vpc.dev_vpc_id}"
  cidr = "10.4.1.0/24"
  tagname = "pub_subnet_1"
  need_public_ip = "true"
  az = "ap-south-1a"
}

module "mod_dev_pub_sub2" {
  source = "./network/subnets/"
  
  vpc_id = "${module.mod_dev_vpc.dev_vpc_id}"
  cidr = "10.4.2.0/24"
  tagname = "pub_subnet_2"
  need_public_ip = "true"
  az = "ap-south-1b"
}

module "mod_dev_pvt_sub1" {
  source = "./network/subnets/"
  
  vpc_id = "${module.mod_dev_vpc.dev_vpc_id}"
  cidr = "10.4.3.0/24"
  tagname = "pvt_subnet_1"
  need_public_ip = "false"
  az = "ap-south-1a"
}
module "mod_dev_pvt_sub2" {
  source = "./network/subnets/"
  
  vpc_id = "${module.mod_dev_vpc.dev_vpc_id}"
  cidr = "10.4.4.0/24"
  tagname = "pvt_subnet_2"
  need_public_ip = "false"
  az = "ap-south-1b"
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

  tagname = "dev_public_route"
}