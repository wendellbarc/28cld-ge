## AWS profile ## 
region  = "us-west-2"
profile = "fiap"

## Database ## 
mysql_instances        = 2
database_instance_type = "db.t3.medium"

## Containers ##
container_memory   = 1024
container_cpu      = 512
desired_containers = 2

## Network ##
cidr_block          = "10.232.0.0/25"
alb_subnets         = ["10.232.0.0/28", "10.232.0.16/28"]
application_subnets = ["10.232.0.32/28", "10.232.0.48/28"]
database_subnets    = ["10.232.0.64/28", "10.232.0.80/28"]

## Default Tags ## 
default_tags = {
  Environment       = "production"
  Terraform_managed = "true"
  Project           = "ge-28cld"
}

## Budget notification ##
mail_notification = ["test@gmail.com"]