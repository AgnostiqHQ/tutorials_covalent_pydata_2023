resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "default" {
  availability_zone = "${var.aws_region}${var.az_suffix}"
}

resource "aws_security_group" "dask" {
  name        = "${var.prefix}-sg"
  description = "Security group for Dask cluster"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "Dask Scheduler"
    from_port   = var.scheduler_port
    to_port     = var.scheduler_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Dask Dashboard"
    from_port   = var.dashboard_port
    to_port     = var.dashboard_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Internal traffic within VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [aws_default_vpc.default.cidr_block]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
