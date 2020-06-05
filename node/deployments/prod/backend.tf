terraform {
  backend "s3" {
    bucket = "prod-nodejs-coaching-demo-statefile"
    key    = "statefile"
    region = "us-east-1"
    endpoint = ""
  }
}