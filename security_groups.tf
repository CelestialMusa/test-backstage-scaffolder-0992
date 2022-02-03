# Only ingress rule is defined for sg's since AWS automatically creates the outbound rule.

resource "aws_security_group" "softeng_web_allow_tls" {
  name        = local.sg_web_allow_tls_name
  description = "Allow TLS inbound traffic into the web service"
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS from Absa CIDR ranges"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }

  tags = merge(
    tomap({ "Name" : local.sg_web_allow_tls_name }),
    local.tags
  )
}

resource "aws_security_group" "softeng_api_allow_traffic" {
  name        = local.sg_api_allow_traffic
  description = "Allows traffic into the API service"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allows traffic from the web security group"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = ["${aws_security_group.softeng_web_allow_tls.id}"]
  }

  tags = merge(
    tomap({ "Name" : local.sg_api_allow_traffic }),
    local.tags
  )
}

resource "aws_security_group" "softeng_postgres_db_allow_traffic" {
  name        = local.sg_postgres_db_allow_traffic
  description = "Allow traffic to and fro the database"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allows inbound traffic from the API security group"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = ["${aws_security_group.softeng_api_allow_traffic.id}"]
  }

  tags = merge(
    tomap({ "Name" : local.sg_postgres_db_allow_traffic }),
    local.tags
  )
}