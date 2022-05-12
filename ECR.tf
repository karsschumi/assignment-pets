terraform {
  backend "s3" {
    bucket = "source-tfstate-bucket"
    key    = "pets"
    region = "us-east-1"
  }
}


resource "aws_ecr_repository" "ecrrepo" {
  name                 = format("%s-%s",var.resource_name_prefix,"repo")
  image_tag_mutability = var.tag_mutability

  image_scanning_configuration {
    scan_on_push = var.image_scan_on_push
  }
}

resource "aws_cloudwatch_log_group" "cwloggroup" {
  name = format("%s-%s",var.resource_name_prefix,"log-group")
  retention_in_days = 7
}