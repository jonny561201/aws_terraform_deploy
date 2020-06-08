terraform {
  backend "s3" {
    bucket = "pilot-nodejs-coaching-demo-statefile"
    key    = "statefile"
    region = "us-east-1"
    endpoint = ""
  }
}