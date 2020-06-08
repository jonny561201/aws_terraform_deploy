//create S3 bucket
resource "aws_s3_bucket" "PythonLambdaDeploy" {
  bucket = "${var.deploy_env}-${var.demo_type}-lambda-deploy-coaching-demo"
  force_destroy = true
  acl = "private"

  tags = {
    Name = "Lambda Deploy"
    Environment = var.deploy_env
  }
}


//copy zip file to S3
resource "aws_s3_bucket_object" "PythonUploadProject" {
  bucket = "${var.deploy_env}-${var.demo_type}-lambda-deploy-coaching-demo"
  key = "lambda_python.zip"
  source = "../../lambda_python.zip"
  depends_on = [aws_s3_bucket.PythonLambdaDeploy]
  etag = filemd5("../../lambda_python.zip")
}
