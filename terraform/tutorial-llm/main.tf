data "aws_caller_identity" "current" {}

provider "aws" {
  region = var.aws_region
}

resource "random_password" "suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "bucket" {
  bucket        = "${var.prefix}-${var.aws_s3_bucket != "" ? var.aws_s3_bucket : random_password.suffix.result}"
  force_destroy = true
}

resource "aws_launch_template" "launch_template" {
  name = "${var.prefix}-launch-template"

  vpc_security_group_ids = [aws_security_group.sg.id]

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 64
    }

  }
}

resource "aws_batch_compute_environment" "compute_environment" {
  compute_environment_name = "${var.prefix}-compute-environment"

  compute_resources {
    instance_role = aws_iam_instance_profile.ecs_instance_role.arn
    instance_type = var.instance_types
    max_vcpus     = var.max_vcpus
    min_vcpus     = var.min_vcpus

    security_group_ids = [aws_security_group.sg.id]

    subnets = [aws_default_subnet.default.id]

    type = "EC2"

    ec2_configuration {
      image_type = "ECS_AL2"
    }

    ec2_configuration {
      image_type = "ECS_AL2_NVIDIA"
    }

    launch_template {
      launch_template_id = aws_launch_template.launch_template.id
    }

    allocation_strategy = "BEST_FIT_PROGRESSIVE"
  }

  service_role = aws_iam_role.aws_batch_service_role.arn
  type         = "MANAGED"
  depends_on   = [aws_iam_role_policy_attachment.aws_batch_service_role_attachment]
}

resource "aws_batch_job_queue" "job_queue" {
  name     = "${var.prefix}-${var.aws_batch_queue}"
  state    = "ENABLED"
  priority = 1
  compute_environments = [
    aws_batch_compute_environment.compute_environment.arn
  ]
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "${var.prefix}-log-group"
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  name           = "${var.prefix}-log-stream"
  log_group_name = aws_cloudwatch_log_group.log_group.name
}
