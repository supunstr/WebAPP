variable "region" {}

# VPC
variable "vpccidr" {}

variable "pubsub01cidr" {}
variable "pubsub02cidr" {}

variable "prisub01cidr" {}
variable "prisub02cidr" {}

# Launch Template
variable "ami-id" {}
variable "instance-type" {}
variable "key" {}
variable "desired" {}
variable "max" {}
variable "min" {}

# database
variable "allocated_storage" {}
variable "max_allocated_storage" {}
variable "engine" {}
variable "engine_version" {}
variable "instance_class" {}
variable "db_name" {}
variable "identifier" {}
variable "username" {}
variable "password" {}
variable "parameter_group_name" {}
variable "backup_window" {}
variable "maintenance_window" {}
variable "port" {}
variable "skip_final_snapshot" {}
variable "multi_az" {}
variable "backup_retention_period" {}

# aws cloud watch metrix
variable "evaluation_periods" {}
variable "metric_name" {}
variable "namespace" {}
variable "period" {}
variable "statistic" {}
variable "threshold_up" {}
variable "threshold_down" {}

# aws autoscaling policy
variable "scaling_adjustment_up" {}
variable "adjustment_type" {}
variable "cooldown" {}
variable "scaling_adjustment_down" {}

# s3 Deatails
variable "s3_bucket" {}
variable "role_policy" {}


