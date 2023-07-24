locals {
  max_capacity = {
    prod = 4
    staging = 1
  }
  min_capacity = {
    prod = 0.5
    staging = 0.5
  }
}

resource "aws_rds_cluster_instance" "products_platform" {
  count              = 1
  identifier         = "products-platform-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.products_platform.cluster_identifier
  instance_class     = "db.serverless"
  engine             = "aurora-postgresql"
  auto_minor_version_upgrade = true
  copy_tags_to_snapshot = false
  monitoring_interval = 0
  promotion_tier = 0
  publicly_accessible = true
  tags = local.tags
}

resource "aws_rds_cluster" "products_platform" {
  backtrack_window = 0
  cluster_identifier = "products-platform"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  database_name      = "products_platform"
  master_username    = local.db_username
  master_password    = local.db_password
  copy_tags_to_snapshot = true
  tags = local.tags
  db_cluster_parameter_group_name = "default.aurora-postgresql13"
  deletion_protection = true
  enable_global_write_forwarding = false
  enabled_cloudwatch_logs_exports = []
  engine = "aurora-postgresql"
  engine_version  = "13.7"
  iam_database_authentication_enabled = false
  iam_roles = []
  serverlessv2_scaling_configuration {
    max_capacity = local.max_capacity[terraform.workspace]
    min_capacity = local.min_capacity[terraform.workspace]
  }
  timeouts {}
}