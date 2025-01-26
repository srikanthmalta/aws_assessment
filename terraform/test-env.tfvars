env    = "test"
org    = "terraform" #betson
region = "eucentral"

#VPC configuration

cidr            = "10.0.0.0/16"
azs             = ["us-central-1a", "us-central-1b"]
private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]

