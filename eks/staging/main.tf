provider "aws" {
  # Tokyo
  region = "ap-northeast-1"
}

terraform {
  backend "local" {
    path = "staging/vpc/terraform.tfstate"
  }
}

module "vpc" {
  source = "../../../modules/vpc"

  env = "staging"
  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-availability-zones
  azs             = ["ap-northeast-1a", "ap-northeast-1c"]
  private_subnets = ["10.0.0.0/19", "10.0.32.0/19"]
  public_subnets  = ["10.0.64.0/19", "10.0.96.0/19"]

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"    = 1
    "kubernetes.io/cluster/staging-demo" = "owned"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb"             = 1
    "kubernetes.io/cluster/staging-demo" = "owned"
  }
}
