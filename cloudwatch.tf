resource "aws_cloudwatch_log_group" "magri-log" {
  name              = "MAGRI-LOGS"
  retention_in_days = "30"

  tags = {
    Application = "magri"
  }
}

resource "aws_iam_role_policy" "magri-log_policy" {
  name = "MAGRI-LOG-POLICY"
  role = aws_iam_role.magri_role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        "Resource" : [
          "arn:aws:logs:*:*:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "magri_role" {
  name = "MAGRI_ROLE"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "magri_profile" {
  name = "magri_profile"
  role = aws_iam_role.magri_role.name
}