variable "app_version" {}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "deploy_env" {
  type = string
  default = "prod"
}

variable "demo_type" {
  type = string
  default = "java"
}

module "lambda_deploy_prod" {
  source = "../common"

  region = var.region
  deploy_env = var.deploy_env
  app_version = var.app_version
  demo_type = var.demo_type
}