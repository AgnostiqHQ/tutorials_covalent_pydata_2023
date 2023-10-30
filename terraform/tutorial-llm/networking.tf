resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "default" {
  availability_zone = "${var.aws_region}${var.az_suffix}"
}

resource "aws_security_group" "sg" {
  name        = "${var.prefix}-sg"
  description = "Allow traffic to Covalent server"
  vpc_id      = aws_default_vpc.default.id

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
