//create S3 bucket
resource "aws_s3_bucket" "JavaLambdaDeploy" {
  bucket = "${var.deploy_env}-${var.demo_type}-lambda-deploy-coaching-demo"
  force_destroy = true
  acl = "private"

  tags = {
    Name = "Lambda Deploy"
    Environment = var.deploy_env
  }
}


//copy zip file to S3
resource "aws_s3_bucket_object" "JavaUploadProject" {
  bucket = "${var.deploy_env}-${var.demo_type}-lambda-deploy-coaching-demo"
  key = "LambdaJava-1.0.jar"
  source = "../../target/LambdaJava-1.0.jar"
  depends_on = [aws_s3_bucket.JavaLambdaDeploy]
  etag = filemd5("../../target/LambdaJava-1.0.jar")
}
