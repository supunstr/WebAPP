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
ami-id        = "ami-0f9a71524d7734680"
instance-type = "t2.micro"
key           = "test"
desired       = "2"
max           = "3"
min           = "2"

# database
allocated_storage       = "50"
max_allocated_storage   = "100"
engine                  = "mysql"
engine_version          = "5.7"
instance_class          = "db.t2.micro"
db_name                 = "dbapp"
identifier              = "dbapp"
username                = "app"
password                = "54_Mg3qaz"
parameter_group_name    = "default.mysql5.7"
backup_window           = "03:00-06:00"
maintenance_window      = "Mon:00:00-Mon:03:00"
port                    = "3306"
skip_final_snapshot     = "true"
multi_az                = "true"
backup_retention_period = "7"

# aws cloud watch metrix
evaluation_periods = "2"
metric_name        = "CPUUtilization"
namespace          = "AWS/EC2"
period             = "120"
statistic          = "Average"
threshold_up       = "80"
threshold_down     = "30"

# aws autoscaling policy
scaling_adjustment_up   = "1"
adjustment_type         = "ChangeInCapacity"
cooldown                = "300"
scaling_adjustment_down = "-1"

# s3 Bucket details
s3_bucket   = "prod-app-images"
role_policy = "Prod-app-bucket-access"