####################################################
# Get current AWS account info (needed for ARNs)
####################################################
data "aws_caller_identity" "current" {}

#create iam role for ECS task execution
resource "aws_iam_role" "ecs-execution-role" {
  name = "ecs-execution-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "ECSExecutionAssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = { Environment = "dev", Project = var.name }
}

# Attach AWS managed policy for ECS execution
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs-execution-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

}

#AmazonEC2ContainerRegistryFullAccess
resource "aws_iam_policy" "ecs_user_ecr_policy" {
  name        = "ecs-user-ecr-policy"
  description = "Allow ecs_user to manage ECR for backend repo"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:DescribeRepositories",
          "ecr:DescribeImages",
          "ecr:GetAuthorizationToken",
          "ecr:CreateRepository",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Resource = "arn:aws:ecr:us-east-1:203918840508:repository/my-react-node-app-repo"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "ecs_user_ecr_custom" {
  user       = "ecs_user"
  policy_arn = aws_iam_policy.ecs_user_ecr_policy.arn
}


# ECS Task Role (Your Node.js app inside ECS)
############################################
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ECSTaskAssumeRole"
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Example: Allow Node app to read objects from S3 (adjust bucket name)
resource "aws_iam_policy" "ecs_task_s3_policy" {
  name        = "ecs-task-s3-access"
  description = "Allow ECS tasks to read from S3 app bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowS3Read"
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:ListBucket"]
        Resource = "arn:aws:s3:::my-react-node-app-bucket02/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_attach_s3" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_task_s3_policy.arn
}

# ECS Task SSM Policy
resource "aws_iam_policy" "ecs_task_ssm_policy" {
  name        = "ecs-task-ssm-access"
  description = "Allow ECS tasks to read SSM parameters"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "AllowSSMRead"
        Effect   = "Allow"
        Action   = ["ssm:GetParameter", "ssm:GetParameters", "ssm:DescribeParameters", "ssm:ListTagsForResource"]
        Resource = "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/${var.name}/*"
      }
    ]
  })
}

# Attach ECS Task Policies
resource "aws_iam_role_policy_attachment" "ecs_task_attach_ssm" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_task_ssm_policy.arn
}


############################################
# S3 Bucket Policy for CloudFront OAC
############################################
# (assuming bucket already defined as aws_s3_bucket.react_app_bucket)
resource "aws_s3_bucket" "my-react-node-app-bucket02" {
  bucket        = "my-react-node-app-bucket02"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "my-react-node-app-bucket02" {
  bucket = aws_s3_bucket.my-react-node-app-bucket02.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontGetObject"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.my-react-node-app-bucket02.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn
          }
        }
      }
    ]
  })
}

#Terraform applying SSM parameters
resource "aws_iam_policy" "ssm_access" {
  name        = "TerraformSSMAccess"
  description = "Allow Terraform to manage SSM parameters for my React-Node app"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:PutParameter",
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:DeleteParameter",
          "ssm:DescribeParameters",
          "ssm:ListTagsForResource",
        ],
        Resource = [
          "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/my-react-node-app/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_ssm" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ssm_access.arn
}