output "ecr_rails_repository_url" {
  value = aws_ecr_repository.rails.repository_url
}

output "ecr_nodejs_repository_url" {
  value = aws_ecr_repository.nodejs.repository_url
}
