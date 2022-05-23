provider "aws" {
  profile = var.profile
  region  = var.region

  default_tags {
    tags = var.default_tags
  }
}

variable "database_instance_type" {}
variable "container_cpu" {}
variable "container_memory" {}
variable "profile" {}
variable "region" {}
variable "desired_containers" {}
variable "mysql_instances" {}
variable "cidr_block" {}
variable "alb_subnets" {}
variable "application_subnets" {}
variable "database_subnets" {}
variable "default_tags" {}
variable "mail_notification" {}