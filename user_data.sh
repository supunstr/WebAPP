#!/bin/bash -v

mkdir -p /data/logs/
mkdir /icons/
apt-get update
apt install awscli -y 

cat  << EOF > /opt/aws/amazon-cloudwatch-agent/bin/config.json
{
    "agent": {
      "metrics_collection_interval": 10,
      "logfile": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log",
      "run_as_user": "root"
    },
    "logs": {
      "logs_collected": {
        "files": {
          "collect_list": [
            {
                "file_path": "/data/logs/application.log",
                "log_group_name":  "MAGRI-LOGS",
                "log_stream_name": "backend-{ip_address}_{instance_id}_logs",
                "timestamp_format": "%d/%b/%Y:%H:%M:%S %z",
                "timezone": "Local"
            }
          ]
        }
      }
    }
  }
EOF

sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s

aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 220848514221.dkr.ecr.ap-southeast-1.amazonaws.com
docker run -idt -p 80:80  -v /data/logs/:/logs/ -v /icons/:/icons/  220848514221.dkr.ecr.ap-southeast-1.amazonaws.com/image-hub:frontend04
docker run -idt -p 8080:8080  -v /data/logs/:/logs/ -v /icons/:/icons/  220848514221.dkr.ecr.ap-southeast-1.amazonaws.com/image-hub:backend04

aws s3 sync  s3://prod-app-images/ /icons/