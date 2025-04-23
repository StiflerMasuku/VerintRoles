terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}


resource "aws_iam_role" "Queue_Statistics" {
  name = "Queue_Statistics"

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

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_policy" "Queue_Statistics_policy" {
  name        = "Queue_Statistics_policy"
  description = "Policy for Queue_StatisticsV1 role"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
         kms:GenerateDataKey"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "connect:ListQueues",
          "connect:GetMetricData"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "Queue_Statistics_attachment" {
  role       = aws_iam_role.Queue_Statistics.name
  policy_arn = aws_iam_policy.Queue_Statistics_policy.arn
}
