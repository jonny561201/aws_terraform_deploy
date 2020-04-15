variable "app_version" {}

variable "region" {
  type = string
  default = "us-east-2"
}

variable "deploy_env" {
  type = string
  default = "pilot"
}

variable "s3_lambda_deploy_bucket" {
  type = string
  default = "jgraf-lambda-deploy-pilot"
}

module "lambda_deploy_pilot" {
  source = "../common"

  region = var.region
  deploy_env = var.deploy_env
  app_version = var.app_version
  s3_lambda_deploy_bucket = var.s3_lambda_deploy_bucket
}