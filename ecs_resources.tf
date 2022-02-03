resource "aws_ecs_cluster" "softeng_ecs_cluster" {
  name = local.ecs_cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(
    tomap({ "Name" : local.ecs_cluster_name }),
    local.tags
  )
}