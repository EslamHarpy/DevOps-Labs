module "vpc" {
  source              = "./modules/vpc"
  project_name        = var.project_name
  region              = var.region
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}

module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
}

module "ec2" {
  source                = "./modules/ec2"
  project_name          = var.project_name
  region                = var.region
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  private_subnet_ids    = module.vpc.private_subnet_ids
  ami_id                = var.ami_id
  instance_type         = var.instance_type
  key_name              = var.key_name
  instance_profile_name = module.iam.instance_profile_name
  ecr_repository_url    = var.ecr_repository_url
}

module "rds" {
  source             = "./modules/rds"
  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  app_sg_id          = module.ec2.app_sg_id
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
}

module "monitoring" {
  source         = "./modules/monitoring"
  project_name   = var.project_name
  admin_email    = var.admin_email
  asg_name       = module.ec2.asg_name
}