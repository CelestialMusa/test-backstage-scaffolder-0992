locals {
  tags = tomap({
    "AppId" : var.AppId,
    "TeamName" : var.TeamName,
    "TeamCode" : var.TeamCode,
    "Department" : var.Department,
    "CostCentre" : var.CostCentre,
    "TeamEmailAddress" : var.TeamEmailAddress,
    "DataConfidentiality" : var.DataConfidentiality,
    "Application" : var.Application,
    "Environment" : var.environment,
    "map-migrated" : var.map-migrated,
    "PersonalData" : var.PersonalData,
    "BuiltBy" : var.BuiltBy
  })

  # ########## Names for generic things ##########
  common_name = lower(join("-", tolist([
    var.region_shorthand,
    var.environment,
    var.TeamCode,
    var.Application
  ])))

  # ########## ECS Related names ##########
  ecs_cluster_name = lower(join("-", tolist([
    local.common_name,
    "cluster"
  ])))


  # ########## Network related items names #########
  web_tg_name = lower(join("-", tolist([
    local.common_name,
    "web",
    "tg"
  ])))

  api_tg_name = lower(join("-", tolist([
    local.common_name,
    "api",
    "tg"
  ])))

  alb_name = lower(join("-", tolist([
    local.common_name,
    "alb"
  ])))

  sg_web_allow_tls_name = lower(join("-", tolist([
    local.common_name,
    "web",
    "sg"
  ])))

  sg_api_allow_traffic = lower(join("-", tolist([
    local.common_name,
    "api",
    "sg"
  ])))

  sg_postgres_db_allow_traffic = lower(join("-", tolist([
    local.common_name,
    "db",
    "sg"
  ])))

  subnets = flatten(["${var.app_subnets}", "${var.data_subnets}"])

  # ########## S3 Bucket related items names #########
  s3_alb_access_logs = lower(join("-", tolist([
    local.common_name,
    "alb-access-logs"
  ])))
}