resource "aws_ecr_repository" "rails" {
  name = "${var.name}"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "nodejs" {
  name = "${var.name}-nodejs"
  image_tag_mutability = "MUTABLE"
}

locals {
  aws_ecr_lifecycle_policy_json = jsonencode({
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

resource "aws_ecr_lifecycle_policy" "rails" {
  repository = aws_ecr_repository.rails.name

  policy = local.aws_ecr_lifecycle_policy_json
}

resource "aws_ecr_lifecycle_policy" "nodejs" {
  repository = aws_ecr_repository.nodejs.name

  policy = local.aws_ecr_lifecycle_policy_json
}
