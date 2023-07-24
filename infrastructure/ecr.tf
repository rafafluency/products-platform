locals {
  ecr_repository_name       = "products-platform"
  ecr_application_image_tag = "latest"
  ecr_migration_image_tag   = "migration-latest"
}

resource "aws_ecr_repository" "app_img_repository" {
  name                 = "products-platform"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  tags                 = local.tags
}

resource "null_resource" "push_application_image" {
  depends_on = [aws_ecr_repository.app_img_repository]

  triggers = {
    docker_file = md5(file("../dockerfiles/Dockerfile"))
  }

  provisioner "local-exec" {
    command = <<EOF
          cd ..
          make aws-build-push-docker-image \
            REGION=${var.region} \
            AWS_ECR_URL=${local.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com \
            DOCKERFILE=dockerfiles/Dockerfile \
            REPO_URL_WITH_TAG=${aws_ecr_repository.app_img_repository.repository_url}:${local.ecr_application_image_tag}
        EOF
  }
}

resource "null_resource" "push_migration_image" {
  depends_on = [aws_ecr_repository.app_img_repository]

  triggers = {
    docker_file = md5(file("../dockerfiles/Migration.Dockerfile"))
  }

  provisioner "local-exec" {
    command = <<EOF
          cd ..
          make aws-build-push-docker-image \
            REGION=${var.region} \
            AWS_ECR_URL=${local.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com \
            DOCKERFILE=dockerfiles/Migration.Dockerfile \
            REPO_URL_WITH_TAG=${aws_ecr_repository.app_img_repository.repository_url}:${local.ecr_migration_image_tag}
        EOF
  }
}

data "aws_ecr_image" "application_image" {
  depends_on = [
    null_resource.push_application_image
  ]

  repository_name = local.ecr_repository_name
  image_tag       = local.ecr_application_image_tag
}

data "aws_ecr_image" "migration_image" {
  depends_on = [
    null_resource.push_migration_image
  ]

  repository_name = local.ecr_repository_name
  image_tag       = local.ecr_migration_image_tag
}
