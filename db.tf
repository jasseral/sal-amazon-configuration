resource "aws_db_instance" "main" {
  allocated_storage = 20
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "8.0"
  instance_class = "db.t2.micro"
  identifier = "sal-${var.env}"
  name = "sal"
  username = var.db_user_name
  password = var.db_root_password
  parameter_group_name = aws_db_parameter_group.default.name
  multi_az = false
  publicly_accessible = true
  deletion_protection = false
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [
    aws_security_group.db.id
  ]
}

resource "aws_db_subnet_group" "main" {
  name = "sal-${var.env}-main"
  subnet_ids = aws_subnet.public.*.id
}

resource "aws_db_parameter_group" "default" {
  name = "sal-${var.env}-mysql8"
  //family = "mysql8"
  family = "MySQL8.0"

  # parameter {
  #   name = "client_encoding"
  #   value = "utf8"
  # }

  # parameter {
  #   name = "work_mem"
  #   value = 16384
  # }

}

resource "aws_security_group" "db" {
  name = "sal-${var.env}-db"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol = "tcp"
    from_port = 3306
    to_port = 3306
    cidr_blocks = [
      "0.0.0.0/0"
    ]

    security_groups = [
      aws_security_group.db_tasks.id
    ]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

# resource "aws_db_event_subscription" "main" {
#   name_prefix = "sal-${var.env}-main"
#   sns_topic = aws_sns_topic.admin.arn

#   source_type = "db-instance"
#   source_ids = [
#     aws_db_instance.main.id
#   ]

#   event_categories = [
#     "failover",
#     "failure",
#     "low storage",
#     "maintenance",
#     "notification",
#     "recovery",
#   ]

# }

# resource "aws_cloudwatch_metric_alarm" "main_db_cpu_utilization_too_high" {
#   alarm_name = "sal-${var.env}-main-db-cpu_utilization_too_high"
#   comparison_operator = "GreaterThanThreshold"
#   evaluation_periods = "1"
#   metric_name = "CPUUtilization"
#   namespace = "AWS/RDS"
#   period = "600"
#   statistic = "Average"
#   threshold = 90
#   alarm_description = "Average database CPU utilization over last 10 minutes too high (> 90%)"
#   alarm_actions = [
#     aws_sns_topic.admin.arn
#   ]
#   ok_actions = [
#     aws_sns_topic.admin.arn
#   ]

#   dimensions = {
#     DBInstanceIdentifier = aws_db_instance.main.id
#   }
# }

# resource "aws_cloudwatch_metric_alarm" "main_db_free_storage_space_too_low" {
#   alarm_name = "sal-${var.env}-main-db-free_storage_space_threshold"
#   comparison_operator = "LessThanThreshold"
#   evaluation_periods = "1"
#   metric_name = "FreeStorageSpace"
#   namespace = "AWS/RDS"
#   period = "600"
#   statistic = "Average"
#   threshold = 3000000000
#   alarm_description = "Average database free storage space over last 10 minutes too low (< 3GB)"
#   alarm_actions = [
#     aws_sns_topic.admin.arn
#   ]
#   ok_actions = [
#     aws_sns_topic.admin.arn
#   ]

#   dimensions = {
#     DBInstanceIdentifier = aws_db_instance.main.id
#   }
# }
