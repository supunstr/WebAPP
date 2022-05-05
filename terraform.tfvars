region = "ap-southeast-1"

# VPC CIDR
vpccidr = "172.29.220.0/24"

# public CIDR
pubsub01cidr = "172.29.220.0/28"
pubsub02cidr = "172.29.220.16/28"

# privert CIDR
prisub01cidr = "172.29.220.32/28"
prisub02cidr = "172.29.220.48/28"

# Launch Template
ami-id        = "ami-029c9b3d4ce054136"
instance-type = "t2.micro"
key           = "test"
desired       = "2"
max           = "3"
min           = "1"

# database
allocated_storage       = "10"
engine                  = "mysql"
engine_version          = "5.7"
instance_class          = "db.t2.micro"
db_name                 = "dbmagri"
identifier              = "dbmagri"
username                = "foo"
password                = "foobarbaz"
parameter_group_name    = "default.mysql5.7"
backup_window           = "03:00-06:00"
maintenance_window      = "Mon:00:00-Mon:03:00"
port                    = "3306"
skip_final_snapshot     = "true"
multi_az                = "true"
backup_retention_period = "7"

