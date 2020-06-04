terraform {
  backend "s3" {
    bucket = "jgraf-pfg-terraform-pilot"
    key    = "statefile"
    region = "us-east-2"
    endpoint = ""
  }
}