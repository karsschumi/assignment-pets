resource "aws_ecr_repository" "ecrrepo" {
  name                 = format("%s-%s",var.resource_name_prefix,"repo")
  image_tag_mutability = var.tag_mutability

  image_scanning_configuration {
    scan_on_push = var.image_scan_on_push
  }
}