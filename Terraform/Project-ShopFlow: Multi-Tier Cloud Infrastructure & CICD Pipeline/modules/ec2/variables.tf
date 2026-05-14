variable "project_name" {}
variable "region" {}
variable "vpc_id" {}
variable "public_subnet_ids" { type = list(string) }
variable "private_subnet_ids" { type = list(string) }
variable "ami_id" { default = "ami-0c55b159cbfafe1f0" } 
variable "instance_type" { default = "t3.micro" }
variable "key_name" {}
variable "instance_profile_name" {}
variable "ecr_repository_url" {}