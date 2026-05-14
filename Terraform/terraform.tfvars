project_name        = "shopflow-prod"
region              = "us-east-1"
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidr  = "10.0.1.0/24"
private_subnet_cidr = "10.0.2.0/24"

ami_id              = "ami-0a59ec92177ec3fad" # Amazon Linux 2
instance_type       = "t3.micro"
key_name            = "k8s"
ecr_repository_url  = "200098097766.dkr.ecr.us-east-1.amazonaws.com/shopflow-app"

db_name             = "shopflowdb"
db_username         = "admin"
db_password         = "SecurePass123!" 

admin_email         = "badreldinwael29@gmail.com"