variable "app_version" {}

variable "region" {
  type = string
  default = "us-east-2"
}

variable "deploy_env" {
  type = string
  default = "prod"
}

module "lambda_deploy_prod" {
  source = "../common"

  deploy_env = var.deploy_env
  region = var.region
  app_version = var.app_version
}