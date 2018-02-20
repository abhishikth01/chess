terraform {
  backend "s3" {
    bucket = "abhi-test-1"
    key    = "tform/dev_terraform.tfstate"
    region = "ap-south-1"
  }
}