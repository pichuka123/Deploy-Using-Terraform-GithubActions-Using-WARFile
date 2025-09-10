module "vpc" {
  source      = "./Terraform-VPC/modules/vpc"
  vpc_cidr    = var.vpc_cidr
  subnet_cidr = var.subnet_cidr
}

module "sg" {
  source = "./Terraform-VPC/modules/sg"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source   = "./Terraform-VPC/modules/ec2"
  sg_id    = module.sg.sg_id
  key_name = "awskeypair"
  subnets  = module.vpc.subnet_ids
}

module "alb" {
  source    = "./Terraform-VPC/modules/alb"
  sg_id     = module.sg.sg_id
  subnets   = module.vpc.subnet_ids
  vpc_id    = module.vpc.vpc_id
  instances = module.ec2.instances
}

