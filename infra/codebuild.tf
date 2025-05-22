# CodeBuild IAM Role
data "aws_iam_policy_document" "codebuild_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codebuild_service_role" {
  name               = "codebuild-service-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json
}

# CodeBuild IAM Policy
resource "aws_iam_role_policy" "codebuild_policy" {
  role = aws_iam_role.codebuild_service_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Resource = [
          "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${local.codebuild_project_name}",
          "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${local.codebuild_project_name}:*"
        ]
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
      },
      {
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::codepipeline-${var.region}-*"
        ]
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ]
      },
      {
        Effect = "Allow"
        Resource = [
          "arn:aws:ecr:${var.region}:${data.aws_caller_identity.current.account_id}:repository/${var.ecr_repository_name}"
        ]
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:GetAuthorizationToken",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
      },
      {
        Effect = "Allow"
        Resource = [
          "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/ecr/*"
        ]
        Action = [
          "ssm:GetParameters",
          "ssm:GetParameter"
        ]
      }
    ]
  })
}

# Local variables
locals {
  codebuild_project_name = "vlm-batch-deployment-builder"
}

# Get AWS account ID
data "aws_caller_identity" "current" {}

# CodeBuild Project
resource "aws_codebuild_project" "docker_build" {
  name          = local.codebuild_project_name
  description   = "Builds Docker image for VLM Batch Deployment"
  build_timeout = "30"
  service_role  = aws_iam_role.codebuild_service_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                      = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                       = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode            = true

    environment_variable {
      name  = "AWS_REGION"
      value = var.region
    }

    environment_variable {
      name  = "ECR_REPO_NAME"
      value = var.ecr_repository_name
    }
  }

  source {
    type            = "NO_SOURCE"
    buildspec       = file("${path.module}/../buildspec.yml")
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/${local.codebuild_project_name}"
      stream_name = "build-log-stream"
      status      = "ENABLED"
    }
  }
} 