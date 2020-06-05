terraform {
  backend "s3" {
    bucket = "prod-python-coaching-demo-statefile"
    key    = "statefile"
    region = "us-east-1"
    endpoint = ""
  }
}