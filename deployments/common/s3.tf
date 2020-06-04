//create S3 bucket
resource "aws_s3_bucket" "lambda_deploy" {
  bucket = "jgraf-lambda-deploy-${var.deploy_env}"
  force_destroy = true
  acl = "private"

  tags = {
    Name = "Lambda Deploy"
    Environment = var.deploy_env
  }
}


//copy zip file to S3
resource "aws_s3_bucket_object" "upload_project" {
  bucket = "jgraf-lambda-deploy-${var.deploy_env}"
  key = "lambda_test_${var.app_version}.zip"
  source = "../../lambda_test_${var.app_version}.zip"
  etag = filemd5("../../lambda_test_${var.app_version}.zip")
  depends_on = [aws_s3_bucket.lambda_deploy]
}
