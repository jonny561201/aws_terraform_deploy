terraform {
  backend "s3" {
    bucket = "jgraf-terraform-pilot"
    key    = "statefile"
    region = "us-east-2"
    endpoint = ""
  }
}