resource "aws_ecr_repository" "main" {
  name = "${var.name}"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.main.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description = "keep last 2 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus = "any"
        countType = "imageCountMoreThan"
        countNumber = 2
      }
    }]
  })
}
