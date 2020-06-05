//create S3 bucket
resource "aws_s3_bucket" "JavaLambdaDeploy" {
  bucket = "${var.demo_type}-${var.deploy_env}-lambda-deploy-coaching-demo"
  force_destroy = true
  acl = "private"

  tags = {
    Name = "Lambda Deploy"
    Environment = var.deploy_env
  }
}


//copy zip file to S3
resource "aws_s3_bucket_object" "JavaUploadProject" {
  bucket = aws_s3_bucket.JavaLambdaDeploy.bucket
  key = "JavaLambda-${var.app_version}-SNAPSHOT.jar"
  source = "../../target/JavaLambda-${var.app_version}-SNAPSHOT.jar"
  depends_on = [aws_s3_bucket.JavaLambdaDeploy]
}
