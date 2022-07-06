# WebAPP

## Infrastructure details
- VPC CIDR - 172.29.220.0/24
- Public Subnet01 CIDR - 172.29.220.0/28
- Public Subnet02 CIDR - 172.29.220.16/28
- Private Subnet01 CIDR - 172.29.220.32/28
- Private Subnet02 CIDR - 172.29.220.48/28

Mainly three security groups are used as follows, 
ALB security group with the port 443 opened to traffic from the internet. ALB is placed in the public subnet.
EC2 security group with ports 80 and 8080 opened to traffic from ALB security group. EC2 are placed in the public subnet.
RDS security group with port 3306 opened to traffic from EC2 security group. RDS is placed in the private subnet.


![Magri (1)](https://user-images.githubusercontent.com/42246100/177541495-d5936f64-6c55-469e-b43e-e39ac944f39d.png)
