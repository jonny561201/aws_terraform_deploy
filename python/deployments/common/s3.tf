//create S3 bucket
resource "aws_s3_bucket" "PythonLambdaDeploy" {
  bucket = "${var.demo_type}-${var.deploy_env}-lambda-deploy-coaching-demo"
  force_destroy = true
  acl = "private"

  tags = {
    Name = "Lambda Deploy"
    Environment = var.deploy_env
  }
}


//copy zip file to S3
resource "aws_s3_bucket_object" "PythonUploadProject" {
  bucket = aws_s3_bucket.PythonLambdaDeploy.bucket
  key = "lambda_test_${var.app_version}.zip"
  source = "../../lambda_test_${var.app_version}.zip"
  depends_on = [aws_s3_bucket.PythonLambdaDeploy]
}
