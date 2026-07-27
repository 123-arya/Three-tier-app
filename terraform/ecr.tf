module "ecr_frontend" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "skillpulse-frontend"

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 30 images"

        selection = {
          tagStatus     = "any"
          countType     = "imageCountMoreThan"
          countNumber   = 20
        }

        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    Terraform   = "true"
  }
}


module "ecr_backend" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "skillpulse-backend"

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 30 images"

        selection = {
          tagStatus     = "any"
          countType     = "imageCountMoreThan"
          countNumber   = 20
        }

        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    Terraform   = "true"
  }
}