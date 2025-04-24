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

data "aws_iam_policy_document" "instance_assume_role_policy" {
     statement {
        actions = ["sts:AssumeRole"]
        principals {
            type  = "Service"
            identifiers = ["ec2.amazonaws.com"]
            }
        }
}

data "aws_iam_policy_document" "Queue_Statistics_Policy" {
    statement {
        actions = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:ListBucket",
            "s3:DeleteBucket",
            "kms:Decrypt",
            "kms:Encrypt",
            "kms:GenerateDataKey",
            "connect:ListQueues",
            "connect:GetMetricData"
        ]
        resources = ["*"]
    }
}

resource "aws_iam_policy" "Queue_Statistics_Policy" {
    name = "Queue_Statistics_Policy"
    description = "Policy for Queue Statistics"
    policy = data.aws_iam_policy_document.Queue_Statistics_Policy.json
}

resource "aws_iam_role_policy_attachment" "Queue_Statistics_Attach" {
    role = aws_iam_role.Queue_Statistics.name
    policy_arn = aws_iam_policy.Queue_Statistics_Policy.arn
}





resource "aws_iam_role" "ASCM" {
  name = "ASCM"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid = ""
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

data "aws_iam_policy_document" "ASCM_Policy" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:DeleteObject",
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey"
      ]
      resources = ["*"]
    }
}

resource "aws_iam_policy" "ASCM_Policy" {
  name = "ASCM_Policy"
  description = "Policy for ASCM"
  policy = data.aws_iam_policy_document.ASCM_Policy.json
}

resource "aws_iam_role_policy_attachment" "ASCM_Attach" {
  role = aws_iam_role.ASCM.name
  policy_arn = aws_iam_policy.ASCM_Policy.arn
}





resource "aws_iam_role" "Adherence" {
  name = "Adherence"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid = ""
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

data "aws_iam_policy_document" "Adherence_Policy" {
  statement {
    actions = [
      "kinesis:DescribeStream",
      "kinesis:GetRecords",
      "kinesis:GetShardIterator",
      "dynamodb:CreateTable",
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:Scan",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "cloudwatch:PutMetricData",
      "kms:Decrypt"
      ]
      resources = ["*"]
    }
}

resource "aws_iam_policy" "Adherence_Policy" {
  name = "Adherence_Policy"
  description = "Policy for Adherence"
  policy = data.aws_iam_policy_document.Adherence_Policy.json
}

resource "aws_iam_role_policy_attachment" "Adherence_Attach" {
  role = aws_iam_role.Adherence.name
  policy_arn = aws_iam_policy.Adherence_Policy.arn
}
