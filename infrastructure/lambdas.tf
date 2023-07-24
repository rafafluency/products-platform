resource "aws_lambda_function" "products_platform_api" {
  function_name = "${local.prefix}-products-platform-api"
  role          = aws_iam_role.iam_for_lambda.arn
  image_uri     = "${aws_ecr_repository.app_img_repository.repository_url}:${data.aws_ecr_image.application_image.image_tag}"
  package_type  = "Image"
  image_config {
    command = ["src.io.consumer.???"]  # O QUE COLOCAR AQUI???
  }
  timeout                        = 30
  reserved_concurrent_executions = 1

  dynamic "vpc_config" {
    for_each = local.is_prod_vpc_config
    content {
      security_group_ids = local.lambda_sg_internet_ids
      subnet_ids         = local.lambda_subnets_internet_ids
    }
  }

  environment {
    variables = {
      APP_NAME      = "${local.prefix}-products-platform-api"
      LOGSTASH_HOST = local.logstash_host
      DATABASE_URL  = "${local.db_username}:${local.db_password}@${aws_rds_cluster.products_platform.endpoint}:${aws_rds_cluster.products_platform.port}/${aws_rds_cluster.products_platform.database_name}"
    }
  }
  tags = local.tags
}

resource "aws_lambda_function" "products_platform_db_migration" {
  function_name = "${local.prefix}-products-platform-db-migration"
  role          = aws_iam_role.iam_for_lambda.arn
  image_uri     = "${aws_ecr_repository.app_img_repository.repository_url}:${data.aws_ecr_image.migration_image.image_tag}"
  package_type  = "Image"
  image_config {
    command = ["migration.function.handler"]
  }
  timeout                        = 30
  reserved_concurrent_executions = 1

  dynamic "vpc_config" {
    for_each = local.is_prod_vpc_config
    content {
      security_group_ids = local.lambda_sg_internet_ids
      subnet_ids         = local.lambda_subnets_internet_ids
    }
  }

  environment {
    variables = {
      APP_NAME     = "${local.prefix}-products-platform-db-migration"
      DATABASE_URL = "${local.db_username}:${local.db_password}@${aws_rds_cluster.products_platform.endpoint}:${aws_rds_cluster.products_platform.port}/${aws_rds_cluster.products_platform.database_name}"
    }
  }
  tags = local.tags
}
