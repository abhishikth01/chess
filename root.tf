module "mod_dev_vpc" {
  source = "./network/vpc/"

  cidr_range = "10.4.0.0/16"
  
  }