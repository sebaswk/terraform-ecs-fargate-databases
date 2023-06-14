resource "aws_ecr_repository" "ecr_image" {
  name                 = lower("Ecr${var.project_name}")
  image_tag_mutability = "MUTABLE"
}
