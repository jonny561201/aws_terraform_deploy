terraform {
  backend "s3" {
    bucket = "jgraf-terraform"
    key    = "statefile"
    region = "us-east-2"
    endpoint = ""
  }
}