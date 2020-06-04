variable "app_version" {}

variable "region" {
  type = string
  default = "us-east-2"
}

variable "deploy_env" {
  type = string
  default = "pilot"
}

module "lambda_deploy" {
  source = "../common"

  region = var.region
  deploy_env = var.deploy_env
  app_version = var.app_version
}