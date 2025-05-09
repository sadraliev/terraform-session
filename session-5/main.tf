resource "aws_sqs_queue" "main" {
  name = replace(local.name, "rtype", "sqs")
  tags = merge(local.common_tags,
  { Name = replace(local.name, "rtype", "sqs") })
}

resource "aws_db_instance" "default" {
  allocated_storage         = 10
  identifier                = replace(local.name, "rtype", "db")
  db_name                   = "main_db"
  engine                    = "mysql"
  engine_version            = "8.0"
  instance_class            = "db.t3.micro"
  username                  = "admin"
  password                  = random_password.main_db_password.result
  parameter_group_name      = "default.mysql8.0"
  skip_final_snapshot       = var.env != "prod" ? true : false
  final_snapshot_identifier = var.env != "prod" ? null : "${var.env}-final-snapshot"
}

resource "random_password" "main_db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

output "main_db_password" {
  value     = random_password.main_db_password.result
  sensitive = true
}
output "name" {
  value = local.name

}
