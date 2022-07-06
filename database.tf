# MAGRI GB creating
resource "aws_db_instance" "appdb" {
  allocated_storage       = var.allocated_storage
  max_allocated_storage   = var.max_allocated_storage
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  db_name                 = var.db_name
  identifier              = var.identifier
  username                = var.username
  password                = var.password
  parameter_group_name    = var.parameter_group_name
  skip_final_snapshot     = var.skip_final_snapshot
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window
  vpc_security_group_ids  = [aws_security_group.app-db.id]
  db_subnet_group_name    = aws_db_subnet_group.db-app.id
  multi_az                = var.multi_az
  port                    = var.port
  backup_retention_period = var.backup_retention_period

  tags = {
    Name : "dbapp"
    Environment = "app"
    Terraform   = "true"
  }
}

resource "aws_db_subnet_group" "db-app" {
  name       = "db-app"
  subnet_ids = [aws_subnet.prisub01.id, aws_subnet.prisub02.id]

  tags = {
    Name        = "DB-APP"
    Environment = "app"
    Terraform   = "true"
  }
}

# creating security group for database open port 3306
resource "aws_security_group" "app-db" {
  name        = "APP-DB"
  description = "Allow 3306 ports inbound from EC2"
  vpc_id      = aws_vpc.vpc-app.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app-forntend.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name : "APP-DB"
    Environment = "app"
    Terraform   = "true"
  }
}