terraform {
  backend "s3" {
    bucket = "jgraf-pfg-terraform-prod"
    key    = "statefile"
    region = "us-east-1"
    endpoint = ""
  }
}