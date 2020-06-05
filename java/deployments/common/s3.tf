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
  key = "JavaLambda-${var.app_version}-SNAPSHOT.jar"
  source = "../../target/JavaLambda-${var.app_version}-SNAPSHOT.jar"
  depends_on = [aws_s3_bucket.JavaLambdaDeploy]
}
