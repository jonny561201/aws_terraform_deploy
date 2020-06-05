terraform {
  backend "s3" {
    bucket = "pilot-java-coaching-demo-statefile"
    key    = "statefile"
    region = "us-east-1"
    endpoint = ""
  }
}