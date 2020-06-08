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
  default = "python"
}

module "lambda_deploy_prod" {
  source = "../common"

  region = var.region
  deploy_env = var.deploy_env
  demo_type =  var.demo_type
}